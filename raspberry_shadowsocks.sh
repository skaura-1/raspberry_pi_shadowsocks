#!/bin/bash

sudo apt-get -y install python-pip python-m2crypto
sudo apt-get -y install shadowsocks

echo " "
echo "Input your shadowsocks server IP:"
read Server
echo "Input your shadowsocks server port:"
read Port
echo "Input your shadowsocks server password:"
read Passwd
echo "Input your shadowsocks server method:"
read Method

sudo echo "
{
    \"server\":\"$Server\",
    \"server_port\":$Port,
    \"local_address\":\"127.0.0.1\",
    \"local_port\":1080,
    \"password\":\"$Passwd\",
    \"timeout\":600,
    \"method\":\"$Method\",
    \"fast_open\":false
}" > /etc/shadowsocks/config.json

sudo sed -i '/libcrypto.EVP_CIPHER_CTX_cleanup.argtypes = (c_void_p,)/c\libcrypto.EVP_CIPHER_CTX_reset.argtypes = (c_void_p,)' /usr/local/lib/python2.7/distpackages/shadowsocks/crypto/openssl.py
sudo sed -i '/libcrypto.EVP_CIPHER_CTX_cleanup.argtypes = (self._ctx)/c\libcrypto.EVP_CIPHER_CTX_reset.argtypes = (self._ctx)' /usr/local/lib/python2.7/distpackages/shadowsocks/crypto/openssl.py

cd /etc
sed -e '/^\exit 0/d' rc.local > rcrc.local
sudo chmod 777 rcrc.local
sudo rm -rf rc.local
sudo mv rcrc.local rc.local
sudo echo "
sudo /usr/bin/sslocal -c /etc/shadowsocks/config.json -d stop
sudo /usr/bin/sslocal -c /etc/shadowsocks/config.json -d start
exit 0
" >> rc.local
sudo chmod 755 /etc/rc.local

sudo /usr/bin/sslocal -c /etc/shadowsocks/config.json -d start

echo "Success to configure your client!"
