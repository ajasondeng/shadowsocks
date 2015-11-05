#! /bin/bash
#===============================================================================================
#   System Required:  Debian or Ubuntu (32bit/64bit)
#   Description:  Install Shadowsocks(libev) for Debian or Ubuntu
#   Author: ajasondeng<ajasondeng@gmail.com>
#===============================================================================================

clear
echo "#############################################################"
echo "# Install Shadowsocks(libev) for Debian or Ubuntu (32bit/64bit)"
echo "#"
echo "# Author: ajasondeng"
echo "#"
echo "#############################################################"
echo ""

# install
apt-get update
apt-get install -y --force-yes build-essential autoconf libtool libssl-dev git curl

#download source code
git clone https://github.com/madeye/shadowsocks-libev.git

#compile install
cd shadowsocks-libev
./configure --prefix=/usr
make && make install
mkdir -p /etc/shadowsocks-libev
cp ./debian/shadowsocks-libev.init /etc/init.d/shadowsocks-libev
cp ./debian/shadowsocks-libev.default /etc/default/shadowsocks-libev
chmod +x /etc/init.d/shadowsocks-libev

# Get IP address(Default No.1)
IP=`curl -s checkip.dyndns.com | cut -d' ' -f 6  | cut -d'<' -f 1`
if [ -z $IP ]; then
   IP=`curl -s ifconfig.me/ip`
fi

#config setting
echo "#############################################################"
echo "#"
echo "# Please input your shadowsocks server_port and password"
echo "#"
echo "#############################################################"
echo ""
echo "input server_port(443 is suggested):"
read serverport
echo "input password:"
read shadowsockspwd

# Config shadowsocks
cat > /etc/shadowsocks-libev/config.json<<-EOF
{
    "server":"${IP}",
    "server_port":${serverport},
    "local_port":1080,
    "password":"${shadowsockspwd}",
    "timeout":60,
    "method":"aes-256-cfb"
}
EOF

#restart
/etc/init.d/shadowsocks-libev restart

#start with boot
update-rc.d shadowsocks-libev defaults
#install successfully
    echo ""
    echo "Congratulations, shadowsocks-libev install completed!"
    echo -e "Your Server IP: ${IP}"
    echo -e "Your Server Port: ${serverport}"
    echo -e "Your Password: ${shadowsockspwd}"
    echo -e "Your Local Port: 1080"
    echo -e "Your Encryption Method:aes-256-cfb"

