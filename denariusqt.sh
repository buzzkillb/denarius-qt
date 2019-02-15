#!/bin/bash
TEMP=/tmp/answer$$
whiptail --title "Denarius [D]"  --menu  "Ubuntu 16.04 QT Installer :" 20 0 0 1 "Install Denarius QT" 2 "Update Denarius QT" 2>$TEMP
choice=`cat $TEMP`
case $choice in
1) echo 1 "Installing Denarius FortunaStake Ubuntu 16.04"

echo "Updating linux packages"
sudo apt-get update -y && apt-get upgrade -y

sudo apt-get --assume-yes install git unzip build-essential libssl-dev libdb++-dev libboost-all-dev libqrencode-dev libminiupnpc-dev libevent-dev autogen automake  libtool libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools

sudo apt-get --assume-yes install qt5-default

echo "Installing Denarius Wallet"
git clone https://github.com/carsenk/denarius
cd denarius || exit
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
cd ~/.denarius || exit
rm -rf database txleveldb smsgDB
#wget http://d.hashbag.cc/chaindata.zip
#unzip chaindata.zip
wget https://github.com/carsenk/denarius/releases/download/v3.3.6/chaindata1612994.zip
unzip chaindata1612994.zip
                ;;
2) echo 2 "Update Denarius QT"
echo "Updating Denarius Wallet"
cd ~/denarius || exit
git checkout master
git pull

echo "Change line in denarius-qt.pro from stdlib=c99 to stdlib=gnu99"
sed -i 's/c99/gnu99/' ~/denarius/denarius-qt.pro

qmake "USE_QRCODE=1" "USE_UPNP=1" denarius-qt.pro
make
                ;;
esac
echo Selected $choice
