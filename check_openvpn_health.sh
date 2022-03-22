#!/bin/bash

set -euo pipefail

echo "Checking route to google.com..."
if ! nc -z -w 1 www.google.com 80 > /dev/null 2>&1 ; then
	echo "🔥 No route to google.com 🔥"
	./restart_openvpn_client.sh
else
	echo "Checking ip..."
	IP=$(curl -Ls https://api.myip.com)
	echo "Current IP: $IP"
	if echo $IP | grep -qiF Germany ; then
		echo "✅ All good! ✅"
	else
		echo "🔥 Bad IP! 🔥"
		./restart_openvpn_client.sh
	fi
fi

echo
