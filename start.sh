#!/bin/bash -x
sudo sysctl -w net.inet.ip.forwarding=1

# sudo sysctl -w net.inet.ip.scopedroute=0
## OSX can't change the net.inet.ip.scopedroute kernel flag in user space so I used:
## sudo defaults write "/Library/Preferences/SystemConfiguration/com.apple.Boot" "Kernel Flags" "net.inet.ip.scopedroute=0"
## and then rebooted
sudo defaults read /Library/Preferences/SystemConfiguration/com.apple.Boot

cat > pf.conf << _EOF_
rdr on en0 inet proto tcp to any port 80 -> 127.0.0.1 port 8080
rdr on en0 inet proto tcp to any port 443 -> 127.0.0.1 port 8080
_EOF_
cat pf.conf

sudo pfctl -d
sudo pfctl -f pf.conf
sudo pfctl -e

mitmproxy -T --host
