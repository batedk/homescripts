if [[ $EUID -ne 0 ]]; then
  echo ""sudo su -" first "
  exit 1
fi

apt-get update && apt-get upgrade -yqq && apt-get autoclean -yqq && apt-get autoremove -yqq

cd /etc/
cp /etc/sysctl.conf sysctl.conf.bak
rm -f /etc/sysctl.conf

cat >/etc/sysctl.conf <<-RCS

vm.swappiness = 1
fs.file-max = 2000000
kernel.pid_max = 4194303
kernel.sched_migration_cost_ns = 5000000
kernel.sched_autogroup_enabled = 0
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_no_metrics_save = 0
net.ipv4.tcp_abort_on_overflow = 0
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_tw_reuse = 1
vm.dirty_background_ratio = 10
vm.dirty_ratio = 30
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_workaround_signed_windows = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_orphan_retries = 2
net.ipv4.tcp_retries2 = 8
net.ipv4.ip_local_port_range = 1024 65535
net.core.netdev_max_backlog = 3240000
net.core.somaxconn = 50000
net.ipv4.tcp_max_tw_buckets = 262144
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_fin_timeout = 60
net.ipv4.tcp_keepalive_time = 7200
net.ipv4.tcp_keepalive_probes = 9
net.ipv4.tcp_max_orphans = 262144
net.ipv4.tcp_mem = 3086631 4115510 6173262
net.ipv4.tcp_timestamps = 0
net.ipv4.ip_no_pmtu_disc = 0
net.core.rmem_default = 16777216
net.core.wmem_default = 16777216
net.core.optmem_max = 16777216
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_budget = 200000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_rmem = 4096 524000 67110000
net.ipv4.tcp_wmem = 4096 524000 67110000
net.ipv4.tcp_adv_win_scale = 2
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

RCS

sleep 5

sysctl -e -p /etc/sysctl.conf

sleep 5

# bullseye Backports + package installation
echo -e "\ndeb http://deb.debian.org/debian bullseye-backports main\n" >>/etc/apt/sources.list
apt-get update 2>&1
apt-get -t bullseye-backports -qq upgrade -y 2>&1
apt-get -t bullseye-backports -qq install linux-image-amd64 -y 2>&1
apt-get -y -qq install zsh tmux nload htop git curl wget screen vim nload mosh hdparm ethtool 2>&1

sleep 5

for nic in $(ifconfig | cut -d':' -f1 | grep -v ' ' | grep -v -e '^$'); do
  ethtool -G $nic rx 4096 2>&1
  ethtool -G $nic tx 4096 2>&1
done

echo "networktools install | please wait"
apt-get install ethtool -yqq 2>&1 >>/dev/null
export DEBIAN_FRONTEND=noninteractive
echo "networktools installed"
sleep 2
network=$(ifconfig | grep -E 'eno1|enp0s|ens5' | awk '{print $1}' | sed -e 's/://g')
sleep 2
echo $network "network detected"
ethtool -K $network tso off tx off
sed -i '$a\' /etc/crontab
sed -i '$a\#################################' /etc/crontab
sed -i '$a\##	Network tweak	  ' /etc/crontab
sed -i '$a\#################################' /etc/crontab
sed -i '$a\@reboot ethtool -K '$network' tso off tx off\' /etc/crontab
sleep 2
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo " Network Tweak done"
echo " Crontab line added"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" && sleep 5
exit
