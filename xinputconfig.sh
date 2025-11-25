#!/bin/sh

set -e

TOUCHPAD_ID=$(xinput list | grep -i 'touchpad' | grep -oP 'id=\K[0-9]+')

if [ -z "$TOUCHPAD_ID" ]; then
    echo "Touchpad device not found."
    exit 1
fi

echo "Touchpad ID: $TOUCHPAD_ID"

NATURAL_SCROLL_PROP=$(xinput list-props "$TOUCHPAD_ID" | grep -i "Natural Scrolling Enabled (" | grep -oP '\(\K[0-9]+')

if [ -n "$NATURAL_SCROLL_PROP" ]; then
    echo "Enabling natural scrolling..."
    xinput set-prop "$TOUCHPAD_ID" "$NATURAL_SCROLL_PROP" 1
fi

TAP_PROP=$(xinput list-props "$TOUCHPAD_ID" | grep -i "Tapping Enabled (" | grep -oP '\(\K[0-9]+')

if [ -n "$TAP_PROP" ]; then
    echo "Enabling tap-to-click..."
    xinput set-prop "$TOUCHPAD_ID" "$TAP_PROP" 1
fi

echo "Touchpad configuration applied."
