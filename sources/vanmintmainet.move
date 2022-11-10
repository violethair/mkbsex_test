address owner {
module vanmintmainet {
    use aptos_framework::account;
    use aptos_token::token::{Self, Token};
    use aptos_framework::coin::{Self, Coin};
    use aptos_framework::aptos_coin::{AptosCoin};
    use aptos_framework::event::{Self, EventHandle};
    use std::option::{Self, Option};
    use std::string::{Self, String};
    use std::signer;
    use std::vector;

    struct Balance_APT has key, store {
        coin: Coin<AptosCoin>,
    }

    struct NFT has key, store {
        locked_token: vector<Option<Token>>,
    }

    struct ClaimEvent has drop, key, store {
        amount: u64,
    }

    struct VanStore has key {
        claim_events: EventHandle<ClaimEvent>,
    }

    const E_NO_CAPABILITIES: u64 = 0;

    const COLLECTION_NAME: vector<u8> = b"Bo suu tap cua vanvan again";
    // const TOKEN_NAME: vector<u8> = b"Token cua vanvan4";

    public entry fun withdrawAPT(account: &signer) acquires Balance_APT {
        let address_account = signer::address_of(account);
        assert!(
            address_account == @owner,
            E_NO_CAPABILITIES,
        );

        let coin = coin::withdraw(account, 1000000000); // 10 APT

        if (!exists<Balance_APT>(@owner)) {
            move_to<Balance_APT>(account, Balance_APT{coin});
        } else {
            let balance = borrow_global_mut<Balance_APT>(@owner);
            coin::merge(&mut balance.coin, coin);
        };
    }

     public entry fun withdrawAPTNew(account: &signer, amount: u64) acquires Balance_APT {
        let address_account = signer::address_of(account);
        assert!(
            address_account == @owner,
            E_NO_CAPABILITIES,
        );

        let coin = coin::withdraw(account, amount); //2500000000 = 25 APT

        if (!exists<Balance_APT>(@owner)) {
            move_to<Balance_APT>(account, Balance_APT{coin});
        } else {
            let balance = borrow_global_mut<Balance_APT>(@owner);
            coin::merge(&mut balance.coin, coin);
        };
    }

    public entry fun withdrawNFT(account: &signer, tokenName: String) acquires NFT {
        let account_address = signer::address_of(account);
        assert!(account_address == @owner, E_NO_CAPABILITIES);

        let token_id = token::create_token_id_raw(@owner, string::utf8(COLLECTION_NAME), tokenName, 0);
        let token = token::withdraw_token(account, token_id, 1);

        if (!exists<NFT>(@owner)) {
            move_to<NFT>(account, NFT {
                locked_token: vector<Option<Token>>[option::some(token)]
            });
        } else {
            let nft = borrow_global_mut<NFT>(@owner);
            let locked_token = &mut nft.locked_token;
            vector::push_back(locked_token, option::some(token));
        };
    }

    public entry fun claimNFT(account: &signer) acquires NFT, VanStore {
        let account_address = signer::address_of(account);

        let nft = borrow_global_mut<NFT>(@owner);
        let locked_token = &mut nft.locked_token;
        let token = vector::pop_back(locked_token);
        token::deposit_token(account, option::extract(&mut token));
        option::destroy_none(token);
        
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
            ClaimEvent { 
                amount: 1,
            }
        );
    }

    public entry fun depositAPT(account: &signer) acquires Balance_APT {
        let address_account = signer::address_of(account);

        let balance = borrow_global_mut<Balance_APT>(@owner);

        let coin_x_opt = coin::extract(&mut balance.coin, 100000000);
        coin::deposit(address_account, coin_x_opt);
    }

    public entry fun claim(account: &signer) acquires NFT, VanStore, Balance_APT {
        let account_address = signer::address_of(account);

        // claim NFT
        let nft = borrow_global_mut<NFT>(@owner);
        let locked_token = &mut nft.locked_token;
        let token = vector::pop_back(locked_token);
        token::deposit_token(account, option::extract(&mut token));
        option::destroy_none(token);

        // claim APT
        let balance = borrow_global_mut<Balance_APT>(@owner);
        let coin_x_opt = coin::extract(&mut balance.coin, 2500000); // 0.025 APT
        coin::deposit(account_address, coin_x_opt);
        
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
            ClaimEvent { 
                amount: 1,
            }
        );
    }
}
}