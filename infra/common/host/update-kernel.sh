#!/bin/bash
#
# We need to have the kernel in at least version 3.18 in order to be able to use overlay driver on Docker
# This script adds the backport repository and installs the most updated kernel found in it
#
# Jon Ribeiro <contact@jonathas.com>
#

if [ `whoami` != 'root' ];then
	echo 'This needs to be run as root'
	exit 1
fi

echo "deb http://mirror.one.com/debian/ jessie-backports main contrib non-free" > /etc/apt/sources.list.d/backports.list

# Install the package and start the machine with the new kernel
apt-get update && apt-get install -t jessie-backports linux-image-amd64 -y && shutdown -r now