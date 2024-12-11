#!/bin/bash

# Constantes
INTERFACE="ens18"
NETMASK="255.255.255.0"
DNS1="1.1.1.1"
CONFIG_FILE="/etc/network/interfaces.d/static"


# Variables
read -p "IP address: " IP_ADDRESS
read -p "Gateway: " GATEWAY

echo "auto $INTERFACE
iface $INTERFACE inet static
    address $IP_ADDRESS
    netmask $NETMASK
    gateway $GATEWAY
    dns-nameservers $DNS1" | tee $CONFIG_FILE > /dev/null
systemctl restart networking
