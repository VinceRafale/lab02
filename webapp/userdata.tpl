#!/usr/bin/env bash

apt-get update -q
apt-get upgrade -y
apt-get install -y git nginx
rm /etc/nginx/sites-enabled/default 
HOST=`hostname`
cat > /etc/nginx/conf.d/webapp.conf <<EOF
server {
    listen 80;
    server_name _;
    root /var/webapp;
}
EOF
git clone https://github.com/d2si/webapp.git /var/webapp
sed -i "s#everybody#${username} at $HOST#" /var/webapp/index.html
service nginx restart
