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
#git clone https://github.com/d2si/webapp.git /var/webapp
mkdir -p /var/webapp/
cp -p /tmp/index.html /var/webapp/
systemctl restart nginx
