#!/bin/sh

set -e

chown -R debian-tor:debian-tor /var/lib/tor

tor &

sleep 5

exec privoxy --no-daemon /etc/privoxy/config
