#! bin/bash

#Bring up a tap0 device. Needs root

if [[ $EUID -ne 0 ]]; then
    echo "You must be root to do this."
    exit 1
fi

ip tuntap add dev tap0 mode tap
ip link set tap0 address fa:46:ee:98:c4:be   # explicit MAC
ip addr add 10.0.0.1/24 dev tap0 #Hardcoded IP. Change if needed
ip link set tap0 up
