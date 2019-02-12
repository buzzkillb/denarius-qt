#!/bin/bash

echo "Updating linux packages"
sudo apt-get update -y && apt-get upgrade -y

sudo apt-get --assume-yes install git unzip build-essential libssl-dev libdb++-dev libboost-all-dev libqrencode-dev libminiupnpc-dev libgmp-dev libevent-dev autogen automake  libtool libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools

sudo apt-get --assume-yes install qt5-default

echo "Installing Denarius Wallet"
git clone https://github.com/carsenk/denarius
cd denarius
git checkout master
git pull

echo "Change line in denarius-qt.pro from stdlib=c99 to stdlib=gnu99"
sed -i 's/c99/gnu99/' ~/denarius/denarius-qt.pro

qmake "USE_QRCODE=1" "USE_UPNP=1" denarius-qt.pro
make

echo "Populate denarius.conf"
mkdir ~/.denarius
echo -e "nativetor=1\naddnode=denarius.host\naddnode=denarius.win\naddnode=denarius.pro\naddnode=triforce.black" > ~/.denarius/denarius.conf

echo "Get Chaindata"
cd ~/.denarius
rm -rf database txleveldb smsgDB
#wget http://d.hashbag.cc/chaindata.zip
#unzip chaindata.zip
wget https://github.com/carsenk/denarius/releases/download/v3.3.6/chaindata1612994.zip
unzip chaindata1612994.zip
