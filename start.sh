#!/bin/sh

set -e

if [ "$(id -u)" = "0" ]; then
    chown -R debian-tor:debian-tor /var/lib/tor
    exec gosu debian-tor tor &
else
    tor &
fi

sleep 5

exec privoxy --no-daemon /etc/privoxy/config
