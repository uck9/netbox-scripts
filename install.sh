#!/usr/bin/env bash

VERSION=3.5-beta1
URL=https://github.com/netbox-community/netbox/archive/refs/tags/v$VERSION.tar.gz
CURDIR=`pwd`

# Install pre-requisites
sudo apt-get install -y postgresql

# Enable and start DB
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Setup postgres
sudo -u postgres psql < ${CURDIR}/conf/postgres.conf

# Install Redis
sudo apt install -y redis-server

# Install app pre-requisites
sudo apt install -y python3 python3-pip python3-venv python3-dev build-essential libxml2-dev libxslt1-dev libffi-dev libpq-dev libssl-dev zlib1g-dev
sudo pip install --upgrade pip

# Download and install app
mkdir /tmp/netbox/
cd /tmp/netbox/
wget ${URL}
tar xzvf v${VERSION}.tar.gz -C /opt/
sudo ln -s /opt/netbox-${VERSION} /opt/netbox

# Create netbox user
sudo adduser --system --group netbox
sudo chown --recursive netbox /opt/netbox/netbox/media/

# Setup configuration
cd /opt/netbox/netbox/netbox/
sudo cp configuration_example.py configuration.py
sudo sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = \['*'\]/" /opt/netbox/netbox/netbox/configuration.py
sudo sed -i "s/'USER': '',/'USER': 'netbox',/" /opt/netbox/netbox/netbox/configuration.py
sudo sed -i "s/'PASSWORD': '',           # PostgreSQL password/'PASSWORD': 'J5brHrAXFLQSif0K',/" /opt/netbox/netbox/netbox/configuration.py
PRIVATE_KEY='aslknfdslakfn3q43qknSKNDKNalisjf23jnlknd2kdn2dsknasdKN'
sudo sed -i "s/SECRET_KEY = ''/SECRET_KEY = '${PRIVATE_KEY}'/" /opt/netbox/netbox/netbox/configuration.py

# Run Upgrade Script
sudo /opt/netbox/upgrade.sh

# Create super user
source /opt/netbox/venv/bin/activate
cd /opt/netbox/netbox
python3 manage.py createsuperuser

# Setup Housekeeping Task
sudo ln -s /opt/netbox/contrib/netbox-housekeeping.sh /etc/cron.daily/netbox-housekeeping

# Install webservers
sudo cp /opt/netbox/contrib/gunicorn.py /opt/netbox/gunicorn.py
sudo cp -v /opt/netbox/contrib/*.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start netbox netbox-rq
sudo systemctl enable netbox netbox-rq

sudo apt install -y nginx
sudo cp /opt/netbox/contrib/nginx.conf /etc/nginx/sites-available/netbox
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/netbox /etc/nginx/sites-enabled/netbox
sudo systemctl restart nginx

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/ssl/private/netbox.key \
-out /etc/ssl/certs/netbox.crt


echo "DONE"
