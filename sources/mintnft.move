address owner {
module mintnft {
    use aptos_token::token::{Self, Token};
    use aptos_token::property_map;
    use std::string::{Self, String};
    use std::bcs;
    use std::option::{Self, Option};
    use std::signer;

    struct GlobalVars has key, store{
        index: u64,
    }

    struct NFT has key, store {
        locked_token: Token,
    }

    struct NFT2 has key, store {
        locked_token: Option<Token>,
    }

    // const E_NO_ADMIN: u64 = 0;
    // const E_NO_CAPABILITIES: u64 = 1;
    // const E_HAS_CAPABILITIES: u64 = 2;
    const MAX_U64: u64 = 18446744073709551615;
    const COLLECTION_NAME: vector<u8> = b"Collection of Alice 6";

    public entry fun init(account: &signer) {
        token::create_collection(
            account,
            string::utf8(COLLECTION_NAME),
            string::utf8(b"Description"),
            string::utf8(b"https://aptos.dev"),
            MAX_U64,
            vector<bool>[ true, true, true, true, true ],
        );

        let default_keys = vector<String>[];
        let default_vals = vector<vector<u8>>[];
        let default_types = vector<String>[];
        let mutate_setting = vector<bool>[true, true, true, true, true];
        token::create_token_script(
            account,
            string::utf8(COLLECTION_NAME),
            string::utf8(b"token cua vanvan"),
            string::utf8(b"Hello, Token"),
            10000,
            MAX_U64,
            string::utf8(b"https://aptos.dev/img/nyan.jpeg"),
            @owner,
            100,
            5,
            mutate_setting,
            default_keys,
            default_vals,
            default_types,
        );

        let token_id = token::create_token_id_raw(signer::address_of(account), string::utf8(COLLECTION_NAME), string::utf8(b"token cua vanvan"), 0);
        let token = token::withdraw_token(account, token_id, 1);

        move_to<NFT2>(account, NFT2{locked_token: option::some(token)});
    }

    public entry fun mint(account: &signer) acquires NFT2 {
        // let global_vars = borrow_global_mut<GlobalVars>(@owner);
        // let tokenName = string::utf8(b"token cua vanvan");
        // let collection = string::utf8(COLLECTION_NAME);
        // let uri = string::utf8(b"https://aptos.dev/img/nyan.jpeg");

        let nft = borrow_global_mut<NFT2>(@owner);
        let token = option::extract(&mut nft.locked_token);
        token::deposit_token(account, token);

        // let token_id = token::create_token_id_raw(@owner, collection, tokenName, 0);
        // let token = Token{
        //     id: token_id,
        //     amount: 1,
        //     token_properties: property_map::empty(),
        // };

        // token::deposit_token(account, token);

        // string::append_utf8(&mut tokenName, bcs::to_bytes<u64>(&global_vars.index));
        // let default_keys = vector<String>[];
        // let default_vals = vector<vector<u8>>[];
        // let default_types = vector<String>[];
        // let mutate_setting = vector<bool>[ true, true, true, true, true ];
        // token::create_token_script(account, collection, tokenName, tokenName, 1, 1, uri, @owner, 100, 50, mutate_setting, default_keys, default_vals, default_types);
        // global_vars.index = global_vars.index + 1;
    }
}
}