FROM node:8-alpine
LABEL maintainer="Jon Ribeiro <contact@jonathas.com>"

ADD rotate-log.sh /usr/local/bin/rotate-log
ADD geoip-download.sh /usr/local/bin/geoip-download

RUN apk update && apk add tzdata && apk add docker &&\ 
    cp /usr/share/zoneinfo/Europe/Prague /etc/localtime &&\ 
    echo "Europe/Prague" > /etc/timezone &&\ 
    apk del tzdata && rm -rf /var/cache/apk/*

CMD chown root:root /etc/crontabs/root && /usr/sbin/crond -f