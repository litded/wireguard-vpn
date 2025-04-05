#!/bin/bash

if [ $# -eq 0 ]
then
	echo "must pass a client name as an arg: add-client.sh new-client"
else
	echo "Creating client config for: $1"
	mkdir -p clients/$1
	wg genkey | tee clients/$1/$1.priv | wg pubkey > clients/$1/$1.pub
	key=$(cat clients/$1/$1.priv)
	ip="10.200.20."$(expr $(cat last-ip.txt | tr "." " " | awk '{print $4}') + 1)
	ip6="fd42:42:42:"$(expr $(cat last-ip6.txt | tr ":" " " | awk '{print $4}') + 1)
	FQDN=$(hostname -f)
  SERVER_PUB_KEY=$(cat /etc/wireguard/publickey)
  cat wg0-client.example.conf | sed -e 's/:CLIENT_IP:/'"$ip"'/' | sed -e 's/:CLIENT_IP6:/'"$ip6"'/' | sed -e 's|:CLIENT_KEY:|'"$key"'|' | sed -e 's|:SERVER_PUB_KEY:|'"$SERVER_PUB_KEY"'|' | sed -e 's|:SERVER_IP:|'"$(wget -qO- https://api.ipify.org)"'|' > clients/$1/wg0.conf
	echo $ip > last-ip.txt
	echo $ip6 > last-ip6.txt
	tar czvf clients/$1.tar.gz clients/$1
	echo "Created config!"
	echo "Adding peer"
	sudo wg set wg0 peer $(cat clients/$1/$1.pub) allowed-ips $ip/32
	echo "Adding peer to hosts file"
	echo $ip" "$1 | sudo tee -a /etc/hosts
	echo $ip6" "$1 | sudo tee -a /etc/hosts
	sudo wg show
	qrencode -t ansiutf8 < clients/$1/wg0.conf
fi
