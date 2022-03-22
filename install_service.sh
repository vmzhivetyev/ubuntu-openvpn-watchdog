#!/bin/bash

set -euo pipefail

set -x

BASE_NAME=vpn_health_checker
SERVICE_NAME=$BASE_NAME.service
TIMER_NAME=$BASE_NAME.timer

INSTALL_PATH=/lib/systemd/system

SERVICE_FILE=$(pwd)/$SERVICE_NAME
TIMER_FILE=$(pwd)/$TIMER_NAME

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
systemctl stop $TIMER_NAME || true
systemctl disable $TIMER_NAME || true


# Verify and install service
systemd-analyze verify $SERVICE_FILE

if [ -f $INSTALL_PATH/$SERVICE_NAME ]; then
	rm $INSTALL_PATH/$SERVICE_NAME
fi
ln -s $SERVICE_FILE $INSTALL_PATH/$SERVICE_NAME

# systemctl enable $SERVICE_NAME


# Verify and install timer
systemd-analyze verify $TIMER_FILE

if [ -f $INSTALL_PATH/$TIMER_NAME ]; then
	rm $INSTALL_PATH/$TIMER_NAME
fi
ln -s $TIMER_FILE $INSTALL_PATH/$TIMER_NAME


# Start service timer
systemctl enable $TIMER_NAME
# systemctl disable $SERVICE_NAME

echo "Run: systemctl start $SERVICE_NAME"
echo "Run: ./watch_log.sh"


