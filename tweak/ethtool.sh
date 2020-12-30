#!/bin/bash
echo "SWARM's Ethtool service started at ${DATE}" | systemd-cat -p info
for nic in $(ifconfig | cut -d':' -f1 | grep -v ' ' | grep -v -e '^$'); do
	ethtool -G $nic rx 4096 2>&1
	ethtool -G $nic tx 4096 2>&1
done
# Looping to keep the service alive
while :; do
	echo "Service looping..."
	sleep 30
done
