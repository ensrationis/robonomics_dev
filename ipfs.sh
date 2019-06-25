#!/usr/bin/env bash

# Init IPFS
[ ! -x ~/.ipfs ] && ipfs init
ipfs daemon --enable-pubsub-experiment &
sleep 5
while [ 1 ]; do
    ipfs swarm connect /dnsaddr/bootstrap.aira.life
    sleep 10
done
