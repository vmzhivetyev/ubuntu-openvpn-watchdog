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
systemctl stop $TIMER_NAME || true
systemctl disable $TIMER_NAME || true
systemctl stop $SERVICE_NAME || true
systemctl disable $SERVICE_NAME || true


# Install service
if [ -f $INSTALL_PATH/$SERVICE_NAME ]; then
	rm $INSTALL_PATH/$SERVICE_NAME
fi
ln -s $SERVICE_FILE $INSTALL_PATH/$SERVICE_NAME
systemd-analyze verify $SERVICE_NAME


# Install timer
if [ -f $INSTALL_PATH/$TIMER_NAME ]; then
	rm $INSTALL_PATH/$TIMER_NAME
fi
ln -s $TIMER_FILE $INSTALL_PATH/$TIMER_NAME
systemd-analyze verify $TIMER_NAME


# Start service timer
systemctl enable $TIMER_NAME
systemctl start $TIMER_NAME


echo "Manual one-time run: systemctl start $SERVICE_NAME"
echo "Watch logs: ./watch_log.sh"


