address owner {
    module vantestnet {
        use std::signer;
        use aptos_framework::account;
        use aptos_framework::event::{Self, EventHandle};
        use aptos_token::token::{Self, Token};
        use std::string::{Self, String};
        use std::bcs;

        const E_CLAIM_LIMIT: u64 = 0;
        const E_NO_CAPABILITIES: u64 = 1;
        const MAX_U64: u64 = 18446744073709551615;
        const COLLECTION_NAME: vector<u8> = b"Ozozoz Collection";
        const TOKEN_NAME: vector<u8> = b"Ozozoz #1";
        const BURNABLE_BY_CREATOR: vector<u8> = b"TOKEN_BURNABLE_BY_CREATOR";

        struct NFT has key, store {
            locked_token: Token
        }

        struct ClaimEvent has key, drop, store {
            amount: u64,
        }

        struct VanStore has key {
            claim_events: EventHandle<ClaimEvent>,
        }

        struct ClaimAmount has key, store {
            amount: u64,
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

            let default_keys = vector<String>[string::utf8(BURNABLE_BY_CREATOR)];
            let default_vals = vector<vector<u8>>[bcs::to_bytes<bool>(&true)];
            let default_types = vector<String>[string::utf8(b"bool")];
           
            token::create_token_script(
                account,
                string::utf8(COLLECTION_NAME),
                string::utf8(TOKEN_NAME),
                string::utf8(b"Hello, Token"),
                1,
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

        public entry fun initNFT2(account: &signer) {
            let account_address = signer::address_of(account);
            assert!(account_address == @owner, E_NO_CAPABILITIES);

            let mutate_setting = vector<bool>[true, true, true, true, true];

            token::create_collection(
                account,
                string::utf8(b"new collection 2"),
                string::utf8(b"Collection: Hello, World"),
                string::utf8(b"https://aptos.dev"),
                1,
                mutate_setting
            );

            let default_keys = vector<String>[string::utf8(BURNABLE_BY_CREATOR)];
            let default_vals = vector<vector<u8>>[];
            let default_types = vector<String>[];
           
            token::create_token_script(
                account,
                string::utf8(b"new collection 2"),
                string::utf8(b"new token 2"),
                string::utf8(b"Hello, Token"),
                1,
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

        public entry fun withdrawNFT(account: &signer) {
            let account_address = signer::address_of(account);
            assert!(account_address == @owner, E_NO_CAPABILITIES);

            let token_id = token::create_token_id_raw(@owner, string::utf8(COLLECTION_NAME), string::utf8(TOKEN_NAME), 0);
            let token = token::withdraw_token(account, token_id, 1);

            move_to<NFT>(account, NFT {
                locked_token: token
            });
        }

        public entry fun claimNFT(account: &signer) acquires NFT, VanStore, ClaimAmount {
            let account_address = signer::address_of(account);
            if (exists<ClaimAmount>(account_address)) {
                let claimAmount = borrow_global_mut<ClaimAmount>(account_address);
                assert!(claimAmount.amount < 3, E_CLAIM_LIMIT);

                claimAmount.amount = claimAmount.amount + 1;
            } else {
                move_to<ClaimAmount>(account, ClaimAmount {
                    amount: 1
                });
            };

            let nft = borrow_global_mut<NFT>(@owner);
            let token = &mut nft.locked_token;
            let split_token = token::split(token, 1);
            token::deposit_token(account, split_token);

            if (!exists<VanStore>(account_address)) {
                move_to<VanStore>(
                    account,
                    VanStore {
                        claim_events: account::new_event_handle<ClaimEvent>(account),
                    },
                );
            };
            let token_store = borrow_global_mut<VanStore>(account_address);
            event::emit_event<ClaimEvent>(
                &mut token_store.claim_events,
                ClaimEvent { amount: 1 },
            );
        }

        public entry fun burnByCreator(account: &signer, owner: address) {
            token::burn_by_creator(
                account,
                owner,
                string::utf8(COLLECTION_NAME),
                string::utf8(TOKEN_NAME),
                0,
                1
            );
        }

        public entry fun burnByOwner(account: &signer, creators_address: address) {
            token::burn(
                account,
                creators_address,
                string::utf8(COLLECTION_NAME),
                string::utf8(TOKEN_NAME),
                0,
                1
            );
        }
    }
}


