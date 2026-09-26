#!/bin/bash

# Get battery percentage
battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)  # Charging/Discharging

# Set a threshold
low_threshold=20
critical_threshold=10

if [[ "$status" == "Discharging" && "$battery_level" -le "$low_threshold" ]]; then
    notify-send -u critical "Battery Low" "Battery at ${battery_level}%! Plug in charger."
fi

if [[ "$status" == "Discharging" && "$battery_level" -le "$critical_threshold" ]]; then
    notify-send -u critical "Battery Critical" "Battery at ${battery_level}%. System may shut down soon!"
fi
