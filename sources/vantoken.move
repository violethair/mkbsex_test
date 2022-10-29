address owner {
    module vantoken {
        use aptos_framework::coin;
        use std::signer;
        use std::string;
        use std::option::{Self, Option};
        use aptos_framework::optional_aggregator::{Self, OptionalAggregator};

        struct VAN{}
       
        struct CoinCapabilities<phantom VAN> has key {
            mint_capability: coin::MintCapability<VAN>,
            burn_capability: coin::BurnCapability<VAN>,
            freeze_capability: coin::FreezeCapability<VAN>,
        }

        struct UserInfo has key, store {
            amount: u64,
            rewardDebt: u64,
            rewardEarn: u64,
        }

        struct GlobalVars has key, store {
            lastReward: u64,
            totalProductivity: u64,
            accAmountPerShare: u64,
            totalReward: u64,
        }

        const E_NO_CAPABILITIES: u64 = 1;
        const PRODUCTIVITY_VALUE_MUST_BE_GREATER_THAN_ZERO: u64 = 2;

        public entry fun init_global_vars(account: &signer) {
            move_to<GlobalVars>(account, GlobalVars{lastReward: 0, totalProductivity: 0, accAmountPerShare: 0, totalReward: 0});
        }

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

        public entry fun burn<VAN>(account: &signer, user: address, amount: u64) acquires CoinCapabilities {
            let account_address = signer::address_of(account);
            assert!(exists<CoinCapabilities<VAN>>(account_address), E_NO_CAPABILITIES);
            let burn_capability = &borrow_global<CoinCapabilities<VAN>>(account_address).burn_capability;
            coin::burn_from<VAN>(user, amount, burn_capability);
        }

        public entry fun burnSelf<VAN>(account: &signer, amount: u64) acquires CoinCapabilities {
            let account_address = signer::address_of(account);
            let burn_capability = &borrow_global<CoinCapabilities<VAN>>(@owner).burn_capability;
            coin::burn_from<VAN>(account_address, amount, burn_capability);
        }

        public entry fun un_freeze_a_user<VAN>(account: &signer, user: address) acquires CoinCapabilities {
            let account_address = signer::address_of(account);
            assert!(exists<CoinCapabilities<VAN>>(account_address), E_NO_CAPABILITIES);
            let freeze_capability = &borrow_global<CoinCapabilities<VAN>>(account_address).freeze_capability;
            coin::unfreeze_coin_store<VAN>(user, freeze_capability);
        }

        public entry fun sign<VAN>(account: &signer, value: u64) {
            assert!(value > 0, PRODUCTIVITY_VALUE_MUST_BE_GREATER_THAN_ZERO);
            let account_address = signer::address_of(account);
            move_to<UserInfo>(account, UserInfo{amount: 0, rewardDebt: 0, rewardEarn: 0});
            // update()
        }

        // fun updateReward(amount: u64) acquires GlobalVars, CoinCapabilities {
        //     let globalVars = borrow_global_mut<GlobalVars>(@owner);
        //     globalVars.lastReward = globalVars.lastReward + amount;
        //     update(globalVars);
        //     globalVars.totalReward = globalVars.lastReward;
        // }

        public entry fun updateReward(account: &signer, amount: u64) acquires GlobalVars, CoinCapabilities {
            let account_address = signer::address_of(account);
            assert!(account_address == @owner, E_NO_CAPABILITIES);
            let globalVars = borrow_global_mut<GlobalVars>(@owner);
            globalVars.lastReward = globalVars.lastReward + amount;
            update(globalVars);
            globalVars.totalReward = globalVars.lastReward;
        }

        fun update(globalVars: &mut GlobalVars) acquires CoinCapabilities {
            let reward = globalVars.lastReward - globalVars.totalReward;
            if (reward == 0) {
                return
            };
            let mint_capability = &borrow_global<CoinCapabilities<VAN>>(@owner).mint_capability;
            let coins = coin::mint<VAN>(reward, mint_capability);
            coin::deposit(@owner, coins);
        }
    }
}


