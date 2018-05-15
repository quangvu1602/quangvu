#!/bin/bash
sudo apt-get update
sudo apt-get install openjdk-8-jdk maven git gcc make -y
sudo apt-get install build-essential -y
sudo apt-get install tsocks
sudo sed -i 's/192.168.0.0/0.0.0.0/g' /etc/tsocks.conf
sudo sed -i 's/255.255.255.0/0.0.0.0/g' /etc/tsocks.conf
sudo sed -i 's/192.168.0.1/38.141.47.57/g' /etc/tsocks.conf
sudo sed -i 's/server_port = 1080/server_port = 1221/g' /etc/tsocks.conf
sudo sed -i 's/server_type = 4/server_type = 5/g' /etc/tsocks.conf
cd
git clone git://github.com/Programmerdan/arionum-java
cd arionum-java/arionum-miner
git checkout investigate
touch config.cfg
chmod 755 config.cfg
echo "pool
http://aropool.com/
47VJTSocAAVkfoJ2o2fW4bQiiukiiAFNvWPsCfgcWZ5FZthq7HJxBMHo9rRe8jvRfSireoZYLJGWY2GTaYWs4M54
20
enhanced
true
hostname" > config.cfg
mvn clean package
chmod +x build-argon.sh
./build-argon.sh
chmod +x run.sh
tsocks tmux new-session -d -s my_session && './run.sh'
