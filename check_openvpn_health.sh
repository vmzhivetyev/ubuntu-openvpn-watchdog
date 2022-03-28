#!/bin/bash

set -euo pipefail

MAX_ATTEMPTS=3
RECHECK_DELAY=20 # seconds before first recheck in a row

function restart_openvpn() {
	echo "Restarting openvpn@client..."
	service openvpn@client restart
}

ATTEMPT=1

while [[ $ATTEMPT -le $MAX_ATTEMPTS ]]; do
	IP=$(curl -Ls https://api.myip.com)
	if echo $IP | grep -qiF Germany ; then
		echo "✅ All good! ✅"
		exit 0
	else
		echo "🔥 Bad IP! $IP 🔥"
		echo "Restart attempt $ATTEMPT/$MAX_ATTEMPTS..."
		restart_openvpn

		ATTEMPT=$(( $ATTEMPT + 1 ))
		DELAY=$(( $RECHECK_DELAY * ($ATTEMPT - 1) )) # wait 20, 40, 60 for rechecks in a row
		echo "Waiting $DELAY seconds before recheck..."
		sleep $DELAY
	fi
done

echo "Reached retries limit. Exiting."