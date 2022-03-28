# ubuntu-openvpn-watchdog
HiveOS helper to restart openvpn if needed.

I decided to check my IP country using https://api.myip.com.

If request fails or response doesn't contain `Germany` (as I'm using a VPN server in Germany) then watchdog restarts `openvpn@client` service.

# Usage

Some things are hardcoded assuming that main script is located at `/home/user/ubuntu-openvpn-watchdog/check_openvpn_health.sh`.

So if you want to use it, you'll need to fork this repo and change paths in scripts (use find and replace in all files).
