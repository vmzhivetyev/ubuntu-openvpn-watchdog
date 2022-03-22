#!/bin/bash

set -euo pipefail

echo "Restarting openvpn@client..."
service openvpn@client restart

echo "sleep 10"
sleep 10

echo "Restarted."

echo "IP after 10 sec: $(curl -Ls https://api.myip.com)"

echo "sleep 10"
sleep 10

echo "IP after 20 sec: $(curl -Ls https://api.myip.com)"

