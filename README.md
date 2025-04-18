# wireguard-vpn


# Установка
```
apt update

apt install git iptables wireguard  wireguard-tools qrencode
```

# Конфигурация
```
git clone https://github.com/litded/wireguard-vpn.git

mkdir -p /etc/wireguard

mv ./wireguard-vpn/* /etc/wireguard/

cd /etc/wireguard

wg genkey | tee /etc/wireguard/privatekey | wg pubkey | tee /etc/wireguard/publickey

echo "PrivateKey = $(cat /etc/wireguard/privatekey)" >> ./wg0.conf

chmod 600 /etc/wireguard/{privatekey,wg0.conf}


echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/99-custom.conf

echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/99-custom.conf

sysctl -p /etc/sysctl.d/99-custom.conf


systemctl enable wg-quick@wg0

systemctl start wg-quick@wg0

systemctl status wg-quick@wg0

reboot
```

# Создать конфиг пользователя
```
cd /etc/wireguard

bash /etc/wireguard/wgpeer.sh vpn1
```

# Вывести QR-код созданного пользователя
```
qrencode -t ansiutf8 < /etc/wireguard/clients/vpn1/wg0.conf
```

# Как подключить?
## Android
Установить WireGuard из PlayMarket и отсканировать QR-код созданного пользователя
## Windows MacOS
Установите официальный клиент и используйте файл конфигурации /etc/wireguard/clients/?/wg0.conf
