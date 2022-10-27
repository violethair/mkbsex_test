module 0x3b92a5a52fbc42ef8a1b611e54617f2a55703bb896aeffb309442c5302dd7f17::vantoken {
    use aptos_framework::coin;
    use std::signer;
    use std::string;

    struct VAN{}

    struct CoinCapabilities<phantom VAN> has key {
        mint_capability: coin::MintCapability<VAN>,
        burn_capability: coin::BurnCapability<VAN>,
        freeze_capability: coin::FreezeCapability<VAN>,
    }

    const E_NO_CAPABILITIES: u64 = 1;

    public entry fun init_token(account: &signer) {
        let (burn_capability, freeze_capability, mint_capability) = coin::initialize<VAN>(
            account,
            string::utf8(b"VAN Token"),
            string::utf8(b"VAN"),
            8,
            true,
        );

        // assert!(signer::address_of(account) == @owner, E_NO_ADMIN);
        // assert!(!exists<CoinCapabilities<AAA>>(@owner), E_HAS_CAPABILITIES);

        move_to<CoinCapabilities<VAN>>(account, CoinCapabilities<VAN>{mint_capability, burn_capability, freeze_capability});
    }

    public entry fun mint<VAN>(account: &signer, amount: u64) acquires CoinCapabilities {
        let account_address = signer::address_of(account);
        assert!(exists<CoinCapabilities<VAN>>(account_address), E_NO_CAPABILITIES);
        let mint_capability = &borrow_global<CoinCapabilities<VAN>>(account_address).mint_capability;
        let coins = coin::mint<VAN>(amount, mint_capability);
        coin::deposit(account_address, coins)
    }

    public fun mint2<VAN>(account: &signer, amount: u64) acquires CoinCapabilities {
        let account_address = signer::address_of(account);
        assert!(exists<CoinCapabilities<VAN>>(account_address), E_NO_CAPABILITIES);
        let mint_capability = &borrow_global<CoinCapabilities<VAN>>(account_address).mint_capability;
        let coins = coin::mint<VAN>(amount, mint_capability);
        coin::deposit(account_address, coins)
    }

    public entry fun freeze_a_user<VAN>(account: &signer, user: address) acquires CoinCapabilities {
        let account_address = signer::address_of(account);
        assert!(exists<CoinCapabilities<VAN>>(account_address), E_NO_CAPABILITIES);
        let freeze_capability = &borrow_global<CoinCapabilities<VAN>>(account_address).freeze_capability;
        coin::freeze_coin_store<VAN>(user, freeze_capability);
    }
}