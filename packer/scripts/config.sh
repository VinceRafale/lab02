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
mkdir -p /var/webapp/
cp -p /tmp/index.html /var/webapp/
sed -e '#everybody#vincent#' /var/webapp/index.html
systemctl restart nginx
