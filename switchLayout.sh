#!/bin/sh
# Simple hyprland keyboard layout switcher.
# using the next command from hyprctl
# Set to current keyboard.
# Can be found at hyprctl devices.
#
keyboard="wooting-wooting-60he-(arm)"

hyprctl switchxkblayout $keyboard next
keymap="$(hyprctl devices | grep  -A 3 "$keyboard$" | grep -Po '(?<=keymap:)\W*\K[^ ]*' )"
hyprctl notify -1 2000 "0" "$keymap"
#notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "$keymap"
