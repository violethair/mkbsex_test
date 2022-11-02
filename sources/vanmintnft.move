address owner {
    module vanmintnft {
        use std::signer;
        use aptos_framework::table::{Self, Table};
        use aptos_token::token::{Self, Token, TokenId};
        use std::string::{Self, String};
        use std::option::{Self, Option};
        use std::vector;

        const E_NO_CAPABILITIES: u64 = 1;
        const MAX_U64: u64 = 18446744073709551615;
        const COLLECTION_NAME: vector<u8> = b"Collection cua vanvan2";
        const TOKEN_NAME: vector<u8> = b"Token cua vanvan2";

        struct NFT has key, store {
            locked_token: Option<Token>,
        }

        struct NFT2 has key, store {
            locked_token: vector<Option<Token>>,
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

        public entry fun withdrawNFT(account: &signer, amount: u64) acquires NFT2 {
            let account_address = signer::address_of(account);
            assert!(account_address == @owner, E_NO_CAPABILITIES);

            let count = 0;
            while(true) {
                let token_id = token::create_token_id_raw(@owner, string::utf8(COLLECTION_NAME), string::utf8(TOKEN_NAME), 0);
                let token = token::withdraw_token(account, token_id, 1);

                if (!exists<NFT2>(@owner)) {
                    move_to<NFT2>(account, NFT2 {
                        locked_token: vector<Option<Token>>[option::some(token)]
                    });
                } else {
                    let nft = borrow_global_mut<NFT2>(@owner);
                    let locked_token = &mut nft.locked_token;
                    vector::push_back(locked_token, option::some(token));
                };

                count = count + 1;

                if (count == amount) {
                    break;
                }

            };
        }

        public entry fun claimNFT(account: &signer) acquires NFT2 {
            let nft = borrow_global_mut<NFT2>(@owner);
            let locked_token = &mut nft.locked_token;
            // let token = vector::pop_back(locked_token);
            // token::deposit_token(account, tokenn);
        }
    }
}


