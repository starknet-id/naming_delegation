from starknet_py.net.models.chains import StarknetChainId
from starknet_py.net.gateway_client import GatewayClient
from starknet_py.net.udc_deployer.deployer import Deployer
from starknet_py.compile.compiler import create_contract_class
from starknet_py.net import AccountClient, KeyPair
import asyncio
import json
import sys

argv = sys.argv

deployer_account_addr = (
    0x072D4F3FA4661228ed0c9872007fc7e12a581E000FAd7b8f3e3e5bF9E6133207
)
deployer_account_private_key = int(argv[1])
# MAINNET: https://alpha-mainnet.starknet.io/
# TESTNET: https://alpha4.starknet.io/
# TESTNET2: https://alpha4-2.starknet.io/
network_base_url = "https://alpha4.starknet.io/"
chainid: StarknetChainId = StarknetChainId.TESTNET
max_fee = int(1e16)
# ethereum contract
erc20 = 0x049D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7
deployer = Deployer()


async def main():
    client = GatewayClient(
        net={
            "feeder_gateway_url": network_base_url + "feeder_gateway",
            "gateway_url": network_base_url + "gateway",
        }
    )
    account: AccountClient = AccountClient(
        client=client,
        address=deployer_account_addr,
        key_pair=KeyPair.from_private_key(deployer_account_private_key),
        chain=chainid,
        supported_tx_version=1,
    )

    braavos_file = open("./build/braavos.json", "r")
    braavos_content = braavos_file.read()
    braavos_file.close()
    declare_contract_tx = await account.sign_declare_transaction(
        compiled_contract=braavos_content, max_fee=max_fee
    )
    braavos_declaration = await client.declare(transaction=declare_contract_tx)
    braavos_json = json.loads(braavos_content)
    abi = braavos_json["abi"]
    print("braavos resolver class hash:", hex(braavos_declaration.class_hash))
    deploy_call, address = deployer.create_deployment_call(
        class_hash=braavos_declaration.class_hash,
        abi=abi,
    )

    resp = await account.execute(deploy_call, max_fee=int(1e16))
    print("deployment txhash:", hex(resp.transaction_hash))
    print("braavos resolver contract address:", hex(address))


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
