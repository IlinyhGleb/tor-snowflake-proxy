#!/bin/sh

set -e

tor &

sleep 5

exec privoxy --no-daemon /etc/privoxy/config
