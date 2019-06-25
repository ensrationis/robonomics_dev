#!/usr/bin/env bash

# Init IPFS
[ ! -x ~/.ipfs ] && ipfs init
ipfs daemon --enable-pubsub-experiment &
sleep 5
while [ 1 ]; do
    ipfs --api /ip4/127.0.0.1/tcp/5001 swarm connect /ip4/35.204.57.79/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8
    sleep 10
done
