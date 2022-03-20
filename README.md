# wireguard-vpn

# Установка
apt update
apt install git iptables wireguard  wireguard-tools qrencode

# Конфигурация
git clone git@github.com:litded/wireguard-vpn.git
mv ./wireguard-vpn /etc/wireguard
cd /etc/wireguard
wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey
cat wg0.example.conf | sed -e 's/:PRIVATEKEY:/'"$(cat /etc/wireguard/privatekey)"'/' > ./wg0.conf
chmod 600 /etc/wireguard/{privatekey,wg0.conf}

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/99-custom.conf
sysctl -p /etc/sysctl.d/99-custom.conf

systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0
systemctl status wg-quick@wg0

# Создать конфиг пользователя
bash /etc/wireguard/wgpeer.sh vpn1

# Вывести QR-код созданного пользователя
qrencode -t ansiutf8 < /etc/wireguard/clients/vpn1/wg0.conf
