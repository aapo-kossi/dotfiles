#!/bin/sh

# Toggles bluetooth default controller power
powered=$(bluetoothctl show | grep Powered | awk '{print $2}')
echo $powered

if [ $powered = yes ]; then
    echo "powering off"
    bluetoothctl -- power off
else
    echo "powering on"
    bluetoothctl -- power on
fi

