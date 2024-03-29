#!/bin/sh
#####################################
# Are we root?
if [[ $EUID -ne 0 ]]; then
	echo "Needs to be ran by root for the installation!"
	exit 1
fi
# write permission to sysctl.conf?
if [ ! -r "/etc/sysctl.conf" ]; then
	echo -e "Cannot acces path $T_PATH1 !" >&2
	exit 1
fi
# Distro info
distribution=$(lsb_release -is)
codename=$(lsb_release -cs)
if [[ ! $distribution =~ ("Debian") ]]; then
	echo "Your distribution ($distribution) is not supported. (at least
    for the time being) only supports Debian."
	exit 1
fi
if [[ ! $codename =~ ("bullseye") ]]; then
	echo "Your release ($codename) of $distribution is not supported (yet!)."
	exit 1
fi
echo "Your system looks good! Let's begin the install process..."

# bullseye Backports + package installation
echo -e "\ndeb http://deb.debian.org/debian bullseye-backports main\n" >>/etc/apt/sources.list
apt-get update 2>&1
apt-get -t bullseye-backports -qq upgrade -y 2>&1
apt-get -t bullseye-backports -qq install linux-image-amd64 -y 2>&1
apt-get -y -qq install zsh tmux nload htop git curl wget screen vim nload mosh hdparm ethtool 2>&1

#NIC tuning
for nic in $(ifconfig | cut -d':' -f1 | grep -v ' ' | grep -v -e '^$'); do
	ethtool -G $nic rx 4096 2>&1
	ethtool -G $nic tx 4096 2>&1
done
curl -s https://raw.githubusercontent.com/batedk/homescripts/master/tweak/sysctl.conf >/etc/sysctl.conf

# SYSCTL
cd /etc/systemd/system/
wget -nc https://raw.githubusercontent.com/batedk/homescripts/master/tweak/sysctl-update.service
wget -nc https://raw.githubusercontent.com/batedk/homescripts/master/tweak/ethtool.service
cd /usr/bin
wget -nc https://raw.githubusercontent.com/batedk/homescripts/master/tweak/ethtool.sh
chmod +x ethtool.sh
wget -nc https://raw.githubusercontent.com/batedk/homescripts/master/tweak/sysctl-update
chmod +x sysctl-update
systemctl daemon-reload
systemctl enable sysctl-update.service
systemctl start sysctl-update.service
systemctl enable ethtool.service
systemctl start ethtool.service
cd /

echo -e "\n\nEnjoy!"
