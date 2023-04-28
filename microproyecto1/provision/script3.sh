#!/bin/bash

echo "Instalamos consul"

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install consul -y

echo "Instalamos haproxy"

sudo apt update && sudo apt upgrade -y
sudo apt install haproxy -y

sudo cp -f haproxy.cfg /etc/haproxy/haproxy.cfg

sudo cp -f config_3.json /etc/consul.d
sudo cp -f consul.service /etc/systemd/system

sudo cp -f 503.http /etc/haproxy/errors/503.http


sudo systemctl daemon-reload
sudo service consul start
sudo service haproxy stop
sudo service haproxy start