address owner {
module vanmintmainet {
    use aptos_framework::coin::{Self, Coin};
    use aptos_framework::aptos_coin::{AptosCoin};
    use std::signer;


    struct Balance_APT has key, store {
        coin: Coin<AptosCoin>,
    }

    const E_NO_CAPABILITIES: u64 = 0;

    public entry fun withdrawAPT(account: &signer) {
        let address_account = signer::address_of(account);
        assert!(
            address_account == @owner,
            E_NO_CAPABILITIES,
        );

        let coin = coin::withdraw(account, 1000000000);
        move_to<Balance_APT>(account, Balance_APT{coin});
    }

    public entry fun depositAPT(account: &signer) acquires Balance_APT {
        let address_account = signer::address_of(account);

        let balance = borrow_global_mut<Balance_APT>(@owner);

        let coin_x_opt = coin::extract(&mut balance.coin, 100000000);
        coin::deposit(address_account, coin_x_opt);
    }
}
}