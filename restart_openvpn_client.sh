#!/bin/bash

set -euo pipefail

function log {
    echo $(date) ">" $@
}

log "Restarting openvpn@client..."
service openvpn@client restart

log "sleep 10"
sleep 10

log "Restarted."

log "IP after 10 sec: $(curl -Ls https://api.myip.com)"

log "sleep 10"
sleep 10

log "IP after 20 sec: $(curl -Ls https://api.myip.com)"

