#!/bin/bash
#
# Logrotation for Nginx
# Jon Ribeiro <contact@jonathas.com>
#
# Based on: https://www.nginx.com/resources/wiki/start/topics/examples/logrotation/
#

TODAY=`date +%Y%m%d`
LOGDIR="/var/log/nginx"
NGINX_MASTER=`ps aux | grep -i nginx | grep master | awk {'print $1'}`

echo "Running log rotation script ..."

# If the filesize is bigger than 3GB
if [[ `ls -l ${LOGDIR}/access.log | awk {'print $5'}` -gt 3017987396 ]]; then
    echo "${TODAY} - Rotating log ..."

    mv $LOGDIR/access.log $LOGDIR/access_${TODAY}.log && 

    # NGINX will re-open its logs in response to the USR1 signal.
    kill -USR1 $NGINX_MASTER && 

    sleep 1 && 

    gzip $LOGDIR/access_${TODAY}.log
else    
    echo "${TODAY} - Nothing to rotate this time"
fi
