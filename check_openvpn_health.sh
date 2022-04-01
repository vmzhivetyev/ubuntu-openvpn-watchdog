#!/bin/bash

set -euo pipefail

MAX_ATTEMPTS=3
RECHECK_DELAY=20 # seconds before first recheck in a row

ATTEMPT=1

while [[ $ATTEMPT -le $MAX_ATTEMPTS ]]; do
	IP=$(curl -Ls https://api.myip.com)
	if echo $IP | grep -qiF Germany ; then
		echo "✅ All good! ✅"
		exit 0
	else
		echo "Restart attempt $ATTEMPT/$MAX_ATTEMPTS..."

		if echo $IP | grep -qiF "<!DOCTYPE html>" ; then
			echo "ℹ️ Looks like myip.com returned rate-limit html page."
		else
			echo "🔥 Bad IP! $IP 🔥"
			echo "Restarting openvpn@client..."
			service openvpn@client restart
		fi

		ATTEMPT=$(( $ATTEMPT + 1 ))
		DELAY=$(( $RECHECK_DELAY * ($ATTEMPT - 1) )) # wait 20, 40, 60 for rechecks in a row
		echo "Waiting $DELAY seconds before recheck..."
		sleep $DELAY
	fi
done

echo "⚠️ Reached retries limit. Exiting."