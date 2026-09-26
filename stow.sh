#!/bin/sh
# Stow the dotfiles into $HOME: the shared "common" package plus the package
# for this setup, "sway" (Arch + sway, Wayland) or "i3" (Debian + i3, X11).
#
#   ./stow.sh          auto-detect
#   ./stow.sh sway     force sway
#   ./stow.sh i3       force i3

set -e

cd "$(dirname "$0")"

wm=$1
if [ -z "$wm" ]; then
    if [ "$XDG_SESSION_TYPE" = wayland ] || [ -n "$WAYLAND_DISPLAY" ]; then
        wm=sway
    elif [ "$XDG_SESSION_TYPE" = x11 ] || [ -n "$DISPLAY" ]; then
        wm=i3
    elif command -v sway >/dev/null; then
        wm=sway
    elif command -v i3 >/dev/null; then
        wm=i3
    else
        echo "Could not detect sway or i3; pass one as an argument." >&2
        exit 1
    fi
fi

case $wm in
    sway) other=i3 ;;
    i3) other=sway ;;
    *) echo "usage: $0 [sway|i3]" >&2; exit 1 ;;
esac

echo "Stowing common + $wm"

# Remove links left over from stowing for the other setup
stow -v -t "$HOME" -D "$other"

stow -v -t "$HOME" common "$wm"
