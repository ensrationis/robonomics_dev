#!/usr/bin/env bash

WORKSPACE=`pwd`

# Build when needed
if [ ! -x ws ]; then
    mkdir -p ws/src && cd ws/src
    catkin_init_workspace
    ln -s $WORKSPACE/robonomics_comm
    cd ..
    catkin_make
    cd ..

    pip3 install eth-keyfile base58 \
                 ipfsapi web3 rospkg \
                 multihash voluptuous \
                 python-persistent-queue \
                 gnupg
fi

# Generate keyfile
if [ ! -e keyfile ]; then
    PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c32)
    echo $PASSWORD > keyfile_password_file
    python3 -c "import os,eth_keyfile,json; print(json.dumps(eth_keyfile.create_keyfile_json(os.urandom(32), '$PASSWORD'.encode())))" > keyfile
fi

# Run IPFS
[ ! -x ~/.ipfs ] && ipfs init
ipfs daemon --enable-pubsub-experiment &
sleep 5
ipfs --api /ip4/127.0.0.1/tcp/5001 swarm connect /ip4/35.204.57.79/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8

# Launch liability
. ws/devel/setup.bash
roslaunch robonomics_liability liability.launch \
    lighthouse_contract:="stable.lighthouse.5.robonomics.eth" \
    keyfile:="$WORKSPACE/keyfile" \
    keyfile_password_file:="$WORKSPACE/keyfile_password_file" \
    web3_http_provider:="https://mainnet.infura.io/v3/cd7368514cbd4135b06e2c5581a4fff7" \
    web3_ws_provider:="wss://mainnet.infura.io/ws" &

sleep 5

roslaunch ethereum_common erc20.launch \
    keyfile:="$WORKSPACE/keyfile" \
    keyfile_password_file:="$WORKSPACE/keyfile_password_file" \
    web3_http_provider:="https://mainnet.infura.io/v3/cd7368514cbd4135b06e2c5581a4fff7" \
    web3_ws_provider:="wss://mainnet.infura.io/ws" &
