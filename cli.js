const fs = require("fs");
const program = require('commander');
const { Tezos } = require('@taquito/taquito');
const { encodeExpr } = require('@taquito/utils');
const { HttpBackend } = require('@taquito/http-utils');
program.version('0.0.1');

const setup = async () => {
    const { email, password, mnemonic, secret } = JSON.parse(fs.readFileSync('./faucet.json').toString())

    Tezos.setProvider({ rpc: "https://rpcalpha.tzbeta.net" })

    await Tezos.importKey(email, password, mnemonic.join(" "), secret)
    return Tezos;
}

program.command("deploy <total_supply>")
    .action(async (total_supply, command) => {
        console.log('Deploying...')
        try {
            const Tezos = await setup();
            const op = await Tezos.contract.originate({
                code: JSON.parse(fs.readFileSync("./build/Token.json").toString()),
                storage: {
                    totalSupply: total_supply,
                    ledger: {
                        [await Tezos.signer.publicKeyHash()]: {
                            balance: total_supply,
                            allowances: {
                                [await Tezos.signer.publicKeyHash()]: total_supply,
                            },
                        }
                    }
                },
            })
            const contract = await op.contract();
            console.log('Deployed at address: ', contract.address)
        } catch (ex) {
            console.error(ex)
        }
    })

const prettyPrint = (obj) => JSON.stringify(obj, null, 2)

program.command("storage <address>")
    .action(async (address, command) => {
        try {
            const Tezos = await setup();
            const contract = await Tezos.contract.at(address)
            const storage = prettyPrint(await contract.storage());
            const rawStorage = prettyPrint(await Tezos.rpc.getStorage(address))
            console.log(`Storage:\n${storage}`)
            console.log(`Raw Storage:\n${rawStorage}`)
        } catch (ex) {
            console.error(ex)
        }
    })

program.command("account")
    .action(async () => {
        try {
            const Tezos = await setup();
            console.log(await Tezos.signer.publicKeyHash())
        } catch (ex) {
            console.error(ex)
        }
    })

program.command("bigMap <address> <key>")
    .action(async (address, keyToEncode, command) => {
        try {
            const Tezos = await setup();
            const contract = await Tezos.contract.at(address)
            const storage = await contract.storage()

            const bigMapID = storage.ledger.id.toString()

            const { key, type } = storage.ledger.schema.EncodeBigMapKey(keyToEncode);
            const { packed } = await Tezos.rpc.packData({ data: key, type });

            const encodedExpr = encodeExpr(packed);

            const bigMapValue = prettyPrint(await storage.ledger.get(keyToEncode))
            const rawBigMapValue = prettyPrint(await Tezos.rpc.getBigMapExpr(bigMapID, encodedExpr));
            console.log(`Storage:\n${bigMapValue}`)
            console.log(`Raw Storage:\n${rawBigMapValue}`)
        } catch (ex) {
            console.error(ex)
        }
    })

program.parse(process.argv);
