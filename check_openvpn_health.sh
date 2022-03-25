#!/bin/bash

echo ''
echo ''

set -euo pipefail

cd /home/user/ubuntu-openvpn-watchdog

MAX_ATTEMPTS=3
RECHECK_DELAY=20 # seconds before first recheck in a row

if ! nc -z -w 1 www.google.com 80 > /dev/null 2>&1 ; then
	echo "🔥 No route to google.com 🔥"
	./restart_openvpn_client.sh
else
	ATTEMPT=1
	
	while [[ $ATTEMPT -le $MAX_ATTEMPTS ]]; do
		IP=$(curl -Ls https://api.myip.com)
		if echo $IP | grep -qiF Germany ; then
			echo "✅ All good! ✅"
			exit 0
		else
			echo "🔥 Bad IP! $IP 🔥"
			echo "Restart attempt $ATTEMPT/$MAX_ATTEMPTS..."
			./restart_openvpn_client.sh

			ATTEMPT=$(( $ATTEMPT + 1 ))
			DELAY=$(( $RECHECK_DELAY * ($ATTEMPT - 1) )) # wait 20, 40, 60 for rechecks in a row
			echo "Waiting $DELAY seconds before recheck..."
			sleep $DELAY
		fi
	done

	echo "Reached retries limit. Exiting."
fi

echo ''
echo ''
