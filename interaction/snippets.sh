NETWORK_NAME="devnet" # devnet, testnet, mainnet

ADDRESS=$(mxpy data load --partition $NETWORK_NAME --key=address)
DEPLOY_TRANSACTION=$(mxpy data load --partition $NETWORK_NAME --key=deploy-transaction)
PROXY=$(mxpy data load --partition $NETWORK_NAME --key=proxy)
CHAIN_ID=$(mxpy data load --partition $NETWORK_NAME --key=chain-id)
MANAGER_ADDRESS=$(mxpy data load --partition $NETWORK_NAME --key=manager-address)

deploy() {
    mxpy contract clean || return
    mxpy contract build || return
    cargo test || return

    mxpy contract deploy \
        --bytecode "output/spawner.wasm" \
        --arguments $MANAGER_ADDRESS \
        --recall-nonce --gas-limit=80000000 \
        --proxy=$PROXY --chain=$CHAIN_ID \
        --outfile="deploy-$NETWORK_NAME.interaction.json" \
        --metadata-payable \
        --metadata-payable-by-sc \
        "${SNIPPETS_SECURE_SIGN_METHOD[@]}" \
        --send || return

    TRANSACTION=$(mxpy data parse --file="deploy-${NETWORK_NAME}.interaction.json" --expression="data['emittedTransactionHash']")
    ADDRESS=$(mxpy data parse --file="deploy-${NETWORK_NAME}.interaction.json" --expression="data['contractAddress']")

    mxpy data store --partition $NETWORK_NAME --key=address --value=$ADDRESS
    mxpy data store --partition $NETWORK_NAME --key=deploy-transaction --value=$TRANSACTION

    echo ""
    echo "deployed smart contract address: $ADDRESS"
}

upgrade() {
    mxpy contract clean || return
    mxpy contract build || return
    cargo test || return

    mxpy contract upgrade $ADDRESS --project . \
        --arguments $MANAGER_ADDRESS \
        --recall-nonce --gas-limit=80000000 \
        --proxy=$PROXY --chain=$CHAIN_ID \
        --metadata-payable \
        --metadata-payable-by-sc \
        "${SNIPPETS_SECURE_SIGN_METHOD[@]}" \
        --send || return
}

# params:
#   $1 = address
addAdmin() {
    mxpy contract call $ADDRESS \
        --function="addAdmin" \
        --arguments $1 \
        --recall-nonce --gas-limit=10000000 \
        --proxy=$PROXY --chain=$CHAIN_ID \
        "${SNIPPETS_SECURE_SIGN_METHOD[@]}" \
        --send || return
}

# params:
#   $1 = address
removeAdmin() {
    mxpy contract call $ADDRESS \
        --function="removeAdmin" \
        --arguments $1 \
        --recall-nonce --gas-limit=10000000 \
        --proxy=$PROXY --chain=$CHAIN_ID \
        "${SNIPPETS_SECURE_SIGN_METHOD[@]}" \
        --send || return
}
