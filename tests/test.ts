// Copyright (c) Aptos
// SPDX-License-Identifier: Apache-2.0

/* eslint-disable no-console */

import dotenv from "dotenv";
dotenv.config();

import { AptosClient, AptosAccount, TokenClient, CoinClient, Types } from "aptos";

const NODE_URL = "https://fullnode.testnet.aptoslabs.com/v1/";
const OWNER_PRIVATE_KEY = "0xe90ffd5f382bb361c4a3460efefe4235ba80042074a21f49f707f33ffafebcf9";

(async () => {
    // Create API and faucet clients.
    // :!:>section_1a
    const client = new AptosClient(NODE_URL);

    // Create client for working with the token module.
    // :!:>section_1b
    // const tokenClient = new TokenClient(client); // <:!:section_1b

    // Create a coin client for checking account balances.
    // const coinClient = new CoinClient(client);

    // Create accounts.
    // :!:>section_2
    // convert private key to private key bytes
    const ownerPrivateKeyBytes = Buffer.from(OWNER_PRIVATE_KEY.slice(2), "hex");
    const owner = new AptosAccount(ownerPrivateKeyBytes);
    // const bob = new AptosAccount(); // <:!:section_2

    // Print out account addresses.
    console.log("=== Addresses ===");
    console.log(`Owner: ${owner.address()}`);
    console.log("");

    // call a function
    // :!:>section_3
    console.log("=== Call a function ===");
    const payloadFunctionId: Types.EntryFunctionId = "0x1::coin::freeze_coin_store";
    const payloadEntryFunction: Types.EntryFunctionPayload = {
        function: payloadFunctionId,
        type_arguments: [
            "0x3b92a5a52fbc42ef8a1b611e54617f2a55703bb896aeffb309442c5302dd7f17::vantoken::VAN"
        ],
        arguments: [
            "0x29fb55d0c30ca485a19be822ad11d2ad5628da4991507f3f7ddb55c7bbd01eba",
            // "1000000000", // 10 coin
        ]
    }
    const rawTransaction = await client.generateTransaction(owner.address(), payloadEntryFunction);
    const signedTransaction = await client.signTransaction(owner, rawTransaction);
    const pendingTransaction = await client.submitTransaction(signedTransaction);

    // wait for transaction to be executed
    await client.waitForTransaction(pendingTransaction.hash);

    // get transaction status
    console.log("Transaction hash: ", pendingTransaction.hash);

    // transfer coin from alice to bob
    // :!:>section_3
    // console.log("=== Transfer Coin From Alice to Bob ===");
    // const payloadFunctionId: Types.EntryFunctionId = "0x1::aptos_account::transfer";
    // const payloadEntryFunction: Types.EntryFunctionPayload = {
    //     function: payloadFunctionId,
    //     type_arguments: [],
    //     arguments: [
    //         bob.address(),
    //         "100000000", // 1 coin
    //     ]
    // }
    // const rawTransaction = await client.generateTransaction(alice.address(), payloadEntryFunction);
    // const signedTransaction = await client.signTransaction(alice, rawTransaction);
    // const tx = await client.submitTransaction(signedTransaction);
    // console.log(`Transaction hash: ${tx.hash}`);
    // console.log("");
    // await client.waitForTransaction(tx.hash);

    // Fund accounts.
    // :!:>section_3
    // await faucetClient.fundAccount(alice.address(), 100_000_000);
    // await faucetClient.fundAccount(bob.address(), 100_000_000); // <:!:section_3

    // console.log("=== Initial Coin Balances ===");
    // console.log(`Alice: ${await coinClient.checkBalance(alice)}`);
    // console.log(`Bob: ${await coinClient.checkBalance(bob)}`);
    // console.log("");

    // console.log("=== Creating Collection and Token ===");
})();