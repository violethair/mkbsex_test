// Copyright (c) Aptos
// SPDX-License-Identifier: Apache-2.0

/* eslint-disable no-console */

import dotenv from "dotenv";
dotenv.config();

import { AptosClient, AptosAccount, TokenClient, CoinClient, Types } from "aptos";

const NODE_URL = "https://fullnode.testnet.aptoslabs.com/v1/";
const ALICE_PRIVATE_KEY = "0xe90ffd5f382bb361c4a3460efefe4235ba80042074a21f49f707f33ffafebcf9";
const BOB_PRIVATE_KEY = "0xb1a5b063dd133b6edd6fdb877521cae54c50cd90cdd7b368484eead7f49b24cd";

(async () => {
    // Create API and faucet clients.
    // :!:>section_1a
    const client = new AptosClient(NODE_URL);

    // Create client for working with the token module.
    // :!:>section_1b
    const tokenClient = new TokenClient(client); // <:!:section_1b

    // Create a coin client for checking account balances.
    // const coinClient = new CoinClient(client);

    // Create accounts.
    // :!:>section_2
    // convert private key to private key bytes
    const alicePrivateKeyBytes = Buffer.from(ALICE_PRIVATE_KEY.slice(2), "hex");
    const alice = new AptosAccount(alicePrivateKeyBytes);
    const bobPrivateKeyBytes = Buffer.from(BOB_PRIVATE_KEY.slice(2), "hex");
    const bob = new AptosAccount(bobPrivateKeyBytes);

    // POST /mint/{address}

    // Print out account addresses.
    console.log("=== Addresses ===");
    console.log(`Alice: ${alice.address()}`);
    console.log(`Bob: ${bob.address()}`);
    // console.log("");

    const collectionName = "Collection of Alice 4"

    // Create the collection.
    // :!:>section_4
    // const txnHash1 = await tokenClient.createCollection(
    //     alice,
    //     collectionName,
    //     "Alice's simple collection",
    //     "https://alice.com",
    // ); // <:!:section_4
    // await client.waitForTransaction(txnHash1, { checkSuccess: true });
    // console.log("Collection created");

    const tokenName = "token cua vanvan";
    // console.log("=== Creating Token ===");
    // const txnHash2 = await tokenClient.createToken(
    //     alice,
    //     collectionName,
    //     tokenName,
    //     "Alice's simple token",
    //     1,
    //     "https://aptos.dev/img/nyan.jpeg",
    //     1,
    //     "0x9cd755e97e8e37741b50303382d092ecb0fbecb00445ff9b9fc6045d605d58a5",
    //     100,
    //     5
    // ); // <:!:section_5
    // await client.waitForTransaction(txnHash2, { checkSuccess: true })
    // console.log("Token created");

    // Alice offers one token to Bob.
    // console.log("\n=== Offer the token to Bob ===");
    // // :!:>section_9
    // const txnHash3 = await tokenClient.offerToken(
    //     alice,
    //     bob.address(),
    //     alice.address(),
    //     collectionName,
    //     tokenName,
    //     1,
    // ); // <:!:section_9
    // await client.waitForTransaction(txnHash3, { checkSuccess: true });
    // console.log(`Offer transaction hash: ${txnHash3}`);

    // Bob claims the token Alice offered him.
    // :!:>section_10
    // const txnHash4 = await tokenClient.claimToken(
    //     bob,
    //     alice.address(),
    //     alice.address(),
    //     collectionName,
    //     tokenName,
    // ); // <:!:section_10
    // await client.waitForTransaction(txnHash4, { checkSuccess: true });
    // console.log(`Claim transaction hash: ${txnHash4}`);

    // const txnHash2 = await tokenClient.createToken(
    //     alice,
    //     collectionName,
    //     tokenName,
    //     "Alice's simple token",
    //     1,
    //     "https://aptos.dev/img/nyan.jpeg",
    //     1,
    //     "0x9cd755e97e8e37741b50303382d092ecb0fbecb00445ff9b9fc6045d605d58a5",
    //     100,
    //     5
    // ); // <:!:section_5
    // await client.waitForTransaction(txnHash2, { checkSuccess: true })
    // console.log("Token created");

    console.log("=== Transfer Direct token From Alice to Bob ===");
    let txnHash5 = await tokenClient.directTransferToken(
        alice,
        bob,
        alice.address(),
        collectionName,
        tokenName,
        1,
    ); // <:!:section_11
    await client.waitForTransaction(txnHash5, { checkSuccess: true });


    // console.log("=== Minting Token ===");

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

    // const collectionName = "Alice's";
    // const tokenName = "Alice's fifth token";
    // const tokenPropertyVersion = 0;

    // const tokenId = {
    //     token_data_id: {
    //         creator: alice.address().hex(),
    //         collection: collectionName,
    //         name: tokenName,
    //     },
    //     property_version: `${tokenPropertyVersion}`,
    // };

    // // Create the collection.
    // // :!:>section_4
    // const txnHash1 = await tokenClient.createCollection(
    //     alice,
    //     collectionName,
    //     "Alice's simple collection",
    //     "https://alice.com",
    // ); // <:!:section_4
    // await client.waitForTransaction(txnHash1, { checkSuccess: true });

    // console.log("=== Test Bob can't create token in Alice's collection ===");
    // try {
    //     const txnHashTest = await tokenClient.createToken(
    //         bob,
    //         collectionName,
    //         tokenName,
    //         "Alice's simple token",
    //         1,
    //         "https://aptos.dev/img/nyan.jpeg",
    //     ); // <:!:section_5
    //     await client.waitForTransaction(txnHashTest, { checkSuccess: true });
    // }
    // catch (e) {
    //     console.log(e);
    //     console.log("Bob can't create token in Alice's collection");
    // }
    // console.log("");
    // return

    // Create a token in that collection.
    // :!:>section_5
    // const txnHash2 = await tokenClient.createToken(
    //     alice,
    //     collectionName,
    //     tokenName,
    //     "Alice's simple token",
    //     1,
    //     "https://aptos.dev/img/nyan.jpeg",
    // ); // <:!:section_5
    // await client.waitForTransaction(txnHash2, { checkSuccess: true });

    // Print the collection data.
    // :!:>section_6
    // const collectionData = await tokenClient.getCollectionData(alice.address(), collectionName);
    // console.log(`Alice's collection: ${JSON.stringify(collectionData, null, 4)}`); // <:!:section_6

    // Get the token balance.
    // :!:>section_7
    // const aliceBalance1 = await tokenClient.getToken(
    //     alice.address(),
    //     collectionName,
    //     tokenName,
    //     `${tokenPropertyVersion}`,
    // );
    // console.log(`Alice's token balance: ${aliceBalance1["amount"]}`); // <:!:section_7

    // Get the token data.
    // :!:>section_8
    // const tokenData = await tokenClient.getTokenData(alice.address(), collectionName, tokenName);
    // console.log(`Alice's token data: ${JSON.stringify(tokenData, null, 4)}`); // <:!:section_8


    // console.log("=== Transfer Direct token From Alice to Bob ===");
    // let txnHash5 = await tokenClient.directTransferToken(
    //     alice,
    //     bob,
    //     alice.address(),
    //     collectionName,
    //     tokenName,
    //     1,
    //     tokenPropertyVersion,
    // ); // <:!:section_11
    // await client.waitForTransaction(txnHash5, { checkSuccess: true });


    // Alice offers one token to Bob.
    // console.log("\n=== Transferring the token to Bob ===");
    // // :!:>section_9
    // const txnHash3 = await tokenClient.offerToken(
    //     alice,
    //     bob.address(),
    //     alice.address(),
    //     collectionName,
    //     tokenName,
    //     1,
    //     tokenPropertyVersion,
    // ); // <:!:section_9
    // await client.waitForTransaction(txnHash3, { checkSuccess: true });
    // console.log(`Offer transaction hash: ${txnHash3}`);

    // // Bob claims the token Alice offered him.
    // // :!:>section_10
    // const txnHash4 = await tokenClient.claimToken(
    //     bob,
    //     alice.address(),
    //     alice.address(),
    //     collectionName,
    //     tokenName,
    //     tokenPropertyVersion,
    // ); // <:!:section_10
    // await client.waitForTransaction(txnHash4, { checkSuccess: true });

    // Print their balances.
    // const aliceBalance2 = await tokenClient.getToken(
    //     alice.address(),
    //     collectionName,
    //     tokenName,
    //     `${tokenPropertyVersion}`,
    // );
    // const bobBalance2 = await tokenClient.getTokenForAccount(bob.address(), tokenId);
    // console.log(`Alice's token balance: ${aliceBalance2["amount"]}`);
    // console.log(`Bob's token balance: ${bobBalance2["amount"]}`);

    // console.log("\n=== Transferring the token back to Alice using MultiAgent ===");
    // // :!:>section_11
    // let txnHash5 = await tokenClient.directTransferToken(
    //     bob,
    //     alice,
    //     alice.address(),
    //     collectionName,
    //     tokenName,
    //     1,
    //     tokenPropertyVersion,
    // ); // <:!:section_11
    // await client.waitForTransaction(txnHash5, { checkSuccess: true });

    // // Print out their balances one last time.
    // const aliceBalance3 = await tokenClient.getToken(
    //     alice.address(),
    //     collectionName,
    //     tokenName,
    //     `${tokenPropertyVersion}`,
    // );
    // const bobBalance3 = await tokenClient.getTokenForAccount(bob.address(), tokenId);
    // console.log(`Alice's token balance: ${aliceBalance3["amount"]}`);
    // console.log(`Bob's token balance: ${bobBalance3["amount"]}`);
})();