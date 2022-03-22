#!/bin/bash

set -euo pipefail

set -x

SERVICE_NAME=vpn_health_checker
INSTALL_PATH=/lib/systemd/system/$SERVICE_NAME.service
SERVICE_FILE=$(pwd)/$SERVICE_NAME.service

if [ ! -f $SERVICE_FILE ]; then
	echo "Error: $SERVICE_FILE doesn't exist"
	exit 1
fi

# Stop service if running
systemctl stop $SERVICE_NAME || true
systemctl disable $SERVICE_NAME || true

# Verify service file
systemd-analyze verify $SERVICE_FILE

# Install service files
if [ -f $INSTALL_PATH ]; then
	rm $INSTALL_PATH
fi
ln -s $SERVICE_FILE $INSTALL_PATH

# Start service
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME


