

address owner {
    module testEditTable {
        use std::signer;
        use std::table::{Self, Table}; 
        use std::string::{Self, String};

        struct ListInfo has key, store {
            amount: u64,
        }

        struct OzTable has key {
            listings: Table<u128, ListInfo>
        }

        public entry fun initStruct(account: &signer) {
            move_to<OzTable>(account, OzTable {
                listings: table::new<u128, ListInfo>(),
            })
        }

        public entry fun createTable(account: &signer) acquires OzTable {
            let listings = &mut borrow_global_mut<OzTable>(@owner).listings;
            table::add(listings, 1, ListInfo {
                amount: 10,
            })
        }

        public entry fun returnListInfo(account: &signer): ListInfo {
            ListInfo{amount: 1}
        }

        public fun editListInfo(listInfo: &mut ListInfo, val: u64) {
            listInfo.amount = val;
        }
    }

    module testUpdateTable {
        use owner::testEditTable::{Self, ListInfo};

        struct SaveListInfo has key {
            listInfo: ListInfo
        }

        public entry fun getListInfo(account: &signer)  {
            let receiveListInfo = testEditTable::returnListInfo(account);
            move_to<SaveListInfo>(account, SaveListInfo {listInfo: receiveListInfo})
        }

        public entry fun updateListInfoToTen(account: &signer) acquires SaveListInfo {
            let listInfo = &mut borrow_global_mut<SaveListInfo>(@owner).listInfo;
            // testEditTable::editListInfo(listInfo, 10);
        }
    }
}


