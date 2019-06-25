robonomics_dev
==============

Requirements
------------

1. Ubuntu 18.04 (Bionic Beaver)

2. ROS Melodic Morenia. [Installation](http://wiki.ros.org/melodic/Installation/Ubuntu)

3. IPFS. [Installation](https://docs.ipfs.io/guides/guides/install/)

4. Pip3. `sudo apt install python3-pip`

Setting up the environment
--------------------------

1. Clone this repo:

```
git clone --recursive https://github.com/airalab/robonomics_dev
```

2. There are two available networks: Mainnet and Sidechain. It's recommended to use Sidechain:

```
cd robonomics_dev
./sidechain_dev.sh
```

> At the first time this script builds `robonomics_comm`, creates `keyfile` and `keyfile_password_file` files

3. Send to the network *Demand* and *Offer* test messages:

```
. ws/devel/setup.bash
rostopic pub /liability/infochan/eth/signing/offer robonomics_msgs/Offer "$(cat test_demand.yaml)" -1
rostopic pub /liability/infochan/eth/signing/demand robonomics_msgs/Demand "$(cat test_offer.yaml)" -1
```

> В момент публикации важно отслеживать состояние соединения с сетью IPFS, например, так `ipfs pubsub peers energyhack2018.lighthouse.3.robonomics.eth`. Если пиры отсутствуют, необходимо выполнить переподключение командой `ipfs swarm connect /dns4/lighthouse.aira.life/tcp/4001/ipfs/QmdfQmbmXt6sqjZyowxPUsmvBsgSGQjm4VXrV7WGy62dv8`.

4. Наблюдаем процесс создания нового обязательства в сети через [Etherscan](https://kovan.etherscan.io/address/0x35db9531330637e3abde2c4a5baa5cf89672f2c4).

5. Наблюдаем, что модуль исполнения подхватил контракт обязательства.

```
[INFO] [1541801196.193975]: Append 0xB53AF1F456d1a1BE928feFDE9a9ffCB8FC0eEebB to liability queue.
[INFO] [1541801196.194399]: Prepare to start liability 0xB53AF1F456d1a1BE928feFDE9a9ffCB8FC0eEebB
```

6. Запускаем обязательство на исполнение.

```
rosservice call /liability/start "address: '0xB53AF1F456d1a1BE928feFDE9a9ffCB8FC0eEebB'"
```

7. Завершаем исполнение обязательства.

```
rosservice call /liability/finish "address: '0xB53AF1F456d1a1BE928feFDE9a9ffCB8FC0eEebB' success: true"
```
