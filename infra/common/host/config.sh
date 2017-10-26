#!/bin/bash
#
# Config script for a Debian server
# Jon Ribeiro <contact@jonathas.com>
#

if [ `whoami` != 'root' ];then
	echo 'This needs to be run as root'
	exit 1
fi

# Kernel has to be at least 3.18 for us to be able to use Docker with overlay driver
if [[ `uname -r` = *"3.16.0"* ]]
then
  echo 'Please run the update-kernel.sh script before running this script'
  exit 1
fi

srcDir="/var/www/skel-server"

# Before running any command, be sure the files belong to the group jon
chown -R jon:jon $srcDir

# Then give access to change the files to any use who is part of the jon group
chmod -R 775 $srcDir

# Link for all the new users
ln -s $srcDir /etc/skel/skel &> /dev/null
ln -s $srcDir /home/jon/skel &> /dev/null

# Make SSH great again!
cp etc/ssh/sshd_config /etc/sshd_config

# Script that links to lynis installation to audit the system
cp sbin/lynis /sbin/lynis

# These next commands are here so Redis and MongoDB docker containers are able to work properly on production
sysctlFile="/etc/sysctl.conf"
somaxconn="net.core.somaxconn=65535"
overcommit="vm.overcommit_memory = 1"
tcp_timestamps="net.ipv4.tcp_timestamps=1"
tcp_tw_recycle="net.ipv4.tcp_tw_recycle=0"
tcp_tw_reuse="net.ipv4.tcp_tw_reuse=1"

if ! grep -q "$somaxconn" $sysctlFile; then
   echo $somaxconn >> $sysctlFile
fi

if ! grep -q "$overcommit" $sysctlFile; then
   echo $overcommit >> $sysctlFile
fi

if ! grep -q "$tcp_timestamps" $sysctlFile; then
    echo $tcp_timestamps >> $sysctlFile
fi

if ! grep -q "$tcp_tw_recycle" $sysctlFile; then
    echo $tcp_tw_recycle >> $sysctlFile
fi

if ! grep -q "$tcp_tw_reuse" $sysctlFile; then
    echo $tcp_tw_reuse >> $sysctlFile
fi

sysctl -p

echo "never" > /sys/kernel/mm/transparent_hugepage/enabled
echo "never" > /sys/kernel/mm/transparent_hugepage/defrag
echo "10240 65535" > /proc/sys/net/ipv4/ip_local_port_range

# So the settings are there again if we need to restart the server
cp etc/rc.local /etc/rc.local