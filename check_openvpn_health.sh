#!/bin/bash

set -euo pipefail

function log {
    echo $(date) ">" $@
}

log "Checking route to google.com..."
if ! nc -z -w 1 www.google.com 80 > /dev/null 2>&1 ; then
	log "🔥 No route to google.com 🔥"
	/home/user/restart_openvpn.sh
else
	log "Checking ip..."
	IP=$(curl -Ls https://api.myip.com)
	log "Current IP: $IP"
	if echo $IP | grep -qiF Germany ; then
		log "✅ All good! ✅"
	else
		log "🔥 Bad IP! 🔥"
		/home/user/restart_openvpn.sh
	fi
fi

echo
