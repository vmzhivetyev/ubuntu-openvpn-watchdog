#!/bin/bash

set -euo pipefail

set -x

SERVICE_NAME=vpn_health_checker
INSTALL_PATH=/lib/systemd/system
SERVICE_FILE=$(pwd)/$SERVICE_NAME.service
TIMER_FILE=$(pwd)/$SERVICE_NAME.timer

if [ ! -f $SERVICE_FILE ]; then
	echo "Error: $SERVICE_FILE doesn't exist"
	exit 1
fi

if [ ! -f $TIMER_FILE ]; then
	echo "Error: $TIMER_FILE doesn't exist"
	exit 1
fi

# Stop service if running
systemctl stop $SERVICE_NAME || true
systemctl disable $SERVICE_NAME || true
systemctl stop $SERVICE_NAME.timer || true
systemctl disable $SERVICE_NAME.timer || true

# Verify service file
systemd-analyze verify $SERVICE_FILE
systemd-analyze verify $TIMER_FILE

# Install service files
if [ -f $INSTALL_PATH/$SERVICE_NAME.service ]; then
	rm $INSTALL_PATH/$SERVICE_NAME.service
fi
ln -s $SERVICE_FILE $INSTALL_PATH/$SERVICE_NAME.service

if [ -f $INSTALL_PATH/$SERVICE_NAME.timer ]; then
	rm $INSTALL_PATH/$SERVICE_NAME.timer
fi
ln -s $TIMER_FILE $INSTALL_PATH/$SERVICE_NAME.timer

# Start service timer
# systemctl enable $SERVICE_NAME
systemctl enable $SERVICE_NAME.timer

echo "Run: systemctl start $SERVICE_NAME"
echo "Run: ./watch_log.sh"


