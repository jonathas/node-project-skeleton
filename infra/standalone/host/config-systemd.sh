#!/bin/bash
#
# Config script for a Debian server
# Jon Ribeiro <contact@jonathas.com>
#

if [ `whoami` != 'root' ];then
	echo 'This needs to be run as root'
	exit 1
fi

# In order to configure Docker to start the containers automatically in case the server is rebooted
cp etc/systemd/system/docker-infra.service /etc/systemd/system

# Reload the daemons list and enable
systemctl daemon-reload
systemctl enable docker-infra