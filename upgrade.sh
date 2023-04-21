#!/usr/bin/env bash

NEW_VERSION=v3.5-beta2
PREV_VERSION=3.5-beta2
CURDIR=`pwd`

wget https://github.com/netbox-community/netbox/archive/v${NEW_VERSION}.tar.gz
sudo tar -xzf v${NEW_VERSION}.tar.gz -C /opt
sudo ln -sfn /opt/netbox-${NEW_VERSION}/ /opt/netbox
sudo cp /opt/netbox-${PREV_VERSION}/local_requirements.txt /opt/netbox/
sudo cp /opt/netbox-${PREV_VERSION}/netbox/netbox/configuration.py /opt/netbox/netbox/netbox/
sudo cp /opt/netbox-${PREV_VERSION}/netbox/netbox/ldap_config.py /opt/netbox/netbox/netbox/
sudo cp -pr /opt/netbox-${PREV_VERSION}/netbox/media/ /opt/netbox/netbox/
sudo cp -r /opt/netbox-${PREV_VERSION}/netbox/scripts /opt/netbox/netbox/
sudo cp -r /opt/netbox-${PREV_VERSION}/netbox/reports /opt/netbox/netbox/
sudo cp /opt/netbox-${PREV_VERSION}/gunicorn.py /opt/netbox/
sudo cd /opt/netbox
sudo ./upgrade.sh
