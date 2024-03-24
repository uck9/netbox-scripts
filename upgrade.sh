#!/usr/bin/env bash

NEW_VERSION=3.6.9
CURR_VERSION=3.6.7
CURDIR=`pwd`

wget https://github.com/netbox-community/netbox/archive/v${NEW_VERSION}.tar.gz
sudo tar -xzf v${NEW_VERSION}.tar.gz -C /opt
sudo ln -sfn /opt/netbox-${NEW_VERSION}/ /opt/netbox
sudo cp /opt/netbox-${CURR_VERSION}/local_requirements.txt /opt/netbox/
sudo cp /opt/netbox-${CURR_VERSION}/netbox/netbox/configuration.py /opt/netbox/netbox/netbox/
sudo cp /opt/netbox-${CURR_VERSION}/netbox/netbox/ldap_config.py /opt/netbox/netbox/netbox/
sudo cp -pr /opt/netbox-${CURR_VERSION}/netbox/media/ /opt/netbox/netbox/
sudo cp -r /opt/netbox-${CURR_VERSION}/netbox/scripts /opt/netbox/netbox/
sudo cp -r /opt/netbox-${CURR_VERSION}/netbox/reports /opt/netbox/netbox/
sudo cp /opt/netbox-${CURR_VERSION}/gunicorn.py /opt/netbox/
cd /opt/netbox
sudo ./upgrade.sh
