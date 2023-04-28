#!/bin/bash

echo "Instalamos consul"

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install consul -y

echo "Instalamos nodejs y npm"

sudo apt update -y
sudo apt install curl dirmngr apt-transport-https lsb-release ca-certificates vim

sudo curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -

sudo apt install nodejs -y
sudo apt install npm -y

npm install consul
npm install express

npm install -g artillery

git clone https://github.com/omondragon/consulService

sudo bash -c "sed -i 's/mymicroservice/web/g' consulService/app/index.js"
sudo bash -c "sed -i 's/192.168.100.3/192.168.100.3/g' consulService/app/index.js"

sudo cp -f config_2.json /etc/consul.d
sudo cp -f consul.service /etc/systemd/system
sudo cp -f web.service /etc/systemd/system

sudo systemctl daemon-reload
sudo service consul stop
sudo service consul start

sudo service web stop
sudo service web start