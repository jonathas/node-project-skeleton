FROM nginx:1.13.5-alpine
LABEL maintainer="Jon Ribeiro <contact@jonathas.com>"

RUN apk update && apk add tzdata bash &&\ 
    cp /usr/share/zoneinfo/Europe/Prague /etc/localtime &&\ 
    echo "Europe/Prague" > /etc/timezone &&\ 
    apk del tzdata && rm -rf /var/cache/apk/*
