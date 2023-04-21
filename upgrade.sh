#!/usr/bin/env bash

VERSION=3.4.7
PREV_VERSION=3.4.8
URL=https://github.com/netbox-community/netbox/archive/refs/tags/v$VERSION.tar.gz
CURDIR=`pwd`

wget https://github.com/netbox-community/netbox/archive/v${VERSION}.tar.gz
sudo tar -xzf v${VERSION}.tar.gz -C /opt
sudo ln -sfn /opt/netbox-${VERSION}/ /opt/netbox
sudo cp /opt/netbox-${PREV_VERSION}/local_requirements.txt /opt/netbox/
sudo cp /opt/netbox-${PREV_VERSION}/netbox/netbox/configuration.py /opt/netbox/netbox/netbox/
sudo cp /opt/netbox-${PREV_VERSION}/netbox/netbox/ldap_config.py /opt/netbox/netbox/netbox/
sudo cp -pr /opt/netbox-${PREV_VERSION}/netbox/media/ /opt/netbox/netbox/
sudo cp -r /opt/netbox-${PREV_VERSION}/netbox/scripts /opt/netbox/netbox/
sudo cp -r /opt/netbox-${PREV_VERSION}/netbox/reports /opt/netbox/netbox/
sudo cp /opt/netbox-${PREV_VERSION}/gunicorn.py /opt/netbox/
sudo cd /opt/netbox
sudo ./upgrade.sh
