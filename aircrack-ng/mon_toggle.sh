#!/bin/bash

# get wireless interface name (first with wireless)
iface=$(iw dev | awk '$1=="Interface"{print $2}' | head -n 1)

if [ -z "$iface" ]; then
    echo "No wireless interface detected"
    exit 1
fi
echo "Wireless interface: $iface"

# get current mode
mode=$(iw dev "$iface" info | awk '$1=="type"{print $2}')
	echo "mode: $mode"

# Switching to monitor mode
if [[ "$mode" == "managed" ]]; then
read -p "channel to force? (1-14): " channel
    echo "starting airmon-ng..."
    sudo airmon-ng start "$iface"
iface_mon=$(iw dev | awk '/Interface/ {print $2}' | grep mon)
    sudo iw "$iface_mon" set channel "$channel"
channel_mon=$(iw dev "$iface_mon" info | awk '/channel/ {print $2}')
	echo "channel: $channel_mon"

#switching to managed mode
elif [[ "$mode" == "monitor" ]]; then
    echo "stopping airmon-ng..."
    sudo airmon-ng stop "$iface"
fi