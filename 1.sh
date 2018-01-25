#!/bin/bash
sudo apt-get install python-software-properties -y

sudo add-apt-repository ppa:ondrej/php -y

sudo apt-get update
sudo apt-get install -y git screen  php7.2 php7.2-gmp
git clone https://github.com/evilbaby/miner
cd miner
sudo chmod +x index.php
screen -dmSL miner ./index.php pool http://aropool.com C5tkic7wXWtyk4YfZoF7f9GWANTk8FjBAGreLcHooMqfdHogm1F3tGTErDdio9njdpaLMtPxdMXswJk6NVvpkqE
screen -dmSL miner1 ./miner pool http://aropool.com C5tkic7wXWtyk4YfZoF7f9GWANTk8FjBAGreLcHooMqfdHogm1F3tGTErDdio9njdpaLMtPxdMXswJk6NVvpkqE
