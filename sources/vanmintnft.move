address owner {
    module vanmintnft {
        use std::signer;
        use aptos_framework::account;
        use aptos_framework::event::{Self, EventHandle};
        use aptos_framework::table::{Self, Table};
        use aptos_token::token::{Self, Token, TokenId};
        use std::string::{Self, String};
        use std::option::{Self, Option};
        use std::vector;

        const E_NO_CAPABILITIES: u64 = 1;
        const MAX_U64: u64 = 18446744073709551615;
        const COLLECTION_NAME: vector<u8> = b"Collection cua vanvan3";
        const TOKEN_NAME: vector<u8> = b"Token cua vanvan3";

        // struct NFT has key, store {
        //     locked_token: Option<Token>,
        // }

        // struct NFT2 has key, store {
        //     locked_token: vector<Option<Token>>,
        // }

        struct NFT3 has key, store {
            locked_token: vector<Option<Token>>,
        }

        struct DepositEventVan has key, drop, store {
            amount: u64,
        }

        struct TokenStore has key {
            deposit_events_van: EventHandle<DepositEventVan>,
        }

        public entry fun initNFT(account: &signer) {
            let account_address = signer::address_of(account);
            assert!(account_address == @owner, E_NO_CAPABILITIES);

            let mutate_setting = vector<bool>[true, true, true, true, true];

            token::create_collection(
                account,
                string::utf8(COLLECTION_NAME),
                string::utf8(b"Collection: Hello, World"),
                string::utf8(b"https://aptos.dev"),
                1,
                mutate_setting
            );

            let default_keys = vector<String>[];
            let default_vals = vector<vector<u8>>[];
            let default_types = vector<String>[];
           
            token::create_token_script(
                account,
                string::utf8(COLLECTION_NAME),
                string::utf8(TOKEN_NAME),
                string::utf8(b"Hello, Token"),
                1000000,
                MAX_U64,
                string::utf8(b"https://aptos.dev/img/nyan.jpeg"),
                account_address,
                100,
                5,
                mutate_setting,
                default_keys,
                default_vals,
                default_types,
            );
        }

        // public entry fun initEvent(account: &signer) {
        //     move_to<TokenStore>(
        //         account,
        //         TokenStore {
        //             deposit_events_van: account::new_event_handle<DepositEventVan>(account),
        //         },
        //     );
        // }

        public entry fun withdrawNFT(account: &signer, amount: u64) acquires NFT3 {
            let account_address = signer::address_of(account);
            assert!(account_address == @owner, E_NO_CAPABILITIES);

            let count = 0;
            while(true) {
                let token_id = token::create_token_id_raw(@owner, string::utf8(COLLECTION_NAME), string::utf8(TOKEN_NAME), 0);
                let token = token::withdraw_token(account, token_id, 1);

                if (!exists<NFT3>(@owner)) {
                    move_to<NFT3>(account, NFT3 {
                        locked_token: vector<Option<Token>>[option::some(token)]
                    });
                } else {
                    let nft = borrow_global_mut<NFT3>(@owner);
                    let locked_token = &mut nft.locked_token;
                    vector::push_back(locked_token, option::some(token));
                };

                count = count + 1;

                if (count == amount) {
                    break;
                }

            };
        }

        public entry fun claimNFT(account: &signer) acquires NFT3, TokenStore {
            let nft = borrow_global_mut<NFT3>(@owner);
            let locked_token = &mut nft.locked_token;
            let token = vector::pop_back(locked_token);
            token::deposit_token(account, option::extract(&mut token));
            option::destroy_none(token);

            let account_address = signer::address_of(account);
            if (!exists<TokenStore>(account_address)) {
                move_to<TokenStore>(
                    account,
                    TokenStore {
                        deposit_events_van: account::new_event_handle<DepositEventVan>(account),
                    },
                );
            };

            let token_store = borrow_global_mut<TokenStore>(account_address);
            event::emit_event<DepositEventVan>(
                &mut token_store.deposit_events_van,
                DepositEventVan { amount: 1 },
            );
        }
    }
}


