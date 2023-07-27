#!/bin/bash

# These are used to find audi sinks. 
# Change the devices and mic. 
speaker="Klipsch"
headset="iFi"
mic_name="Razer"

# Greps to find sources.
currentsink="$(pamixer --get-default-sink| grep -oiP "$headset|$speaker" | head -n 1 )" || exit 1
findsink="$(pamixer --get-default-sink| grep -Eo '^[0-9]{1,3}' )"
speakersink="$(pamixer --list-sinks| grep -iP "$speaker" | grep -Eo '^[0-9]{1,3}' | head -n 1 )"
headsetSink="$(pamixer --list-sinks| grep -iP "$headset" | grep -Eo '^[0-9]{1,2}' | head -n 1 )"
currentsource=$(pamixer --list-sources| grep -iP "$mic_name" | grep -Eo '^[0-9]{1,2}' | head -n 1)

toggle_mic() {

	if [ "$(pamixer --source $currentsource --get-mute)" == "false" ]; then
		pamixer -t --source $currentsource
		hyprctl notify -1 2000 "0" "Muted Mic"
	elif [ "$(pamixer --source $currentsource --get-mute)" == "true" ]; then
		pamixer -t --source $currentsource
		hyprctl notify -1 2000 "0" "Umuted Mic"

	fi
}

toggle_sink() {
	if [ "$currentsink" == "$speaker" ]; then
		pactl set-default-sink $headsetSink
		hyprctl notify -1 2000 "0" "Headset"

	elif [ "$currentsink" == "$headset" ]; then
		pactl set-default-sink $speakersink
		hyprctl notify -1 2000 "0" "Speaker"
	fi
}


if [[ "$1" == "--toggle_mic" ]]; then
	toggle_mic
elif [[ "$1" == "--toggle_mute" ]]; then
	toggle_mic
	$(pamixer -t)
	hyprctl notify -1 2000 "0" "And audio"
elif [[ "$1" == "--toggle_sink" ]]; then
	toggle_sink
fi














#
# iDIR="$HOME/.config/hypr/mako/icons"


# Execute accordingly
# if [[ "$1" == "--get" ]]; then
# 	get_volume
# elif [[ "$1" == "--inc" ]]; then
# 	inc_volume
# elif [[ "$1" == "--dec" ]]; then
# 	dec_volume
# elif [[ "$1" == "--get-icon" ]]; then
# 	get_icon
#



# get_volume() {
# 	volume=$(pamixer --get-volume)
# 	echo "$volume"
# }
#

# Put near top if used..
#
# # Get icons
# get_icon() {
# 	current=$(get_volume)
# 	if [[ "$current" -eq "0" ]]; then
# 		echo "$iDIR/volume-mute.png"
# 	elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
# 		echo "$iDIR/volume-low.png"
# 	elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
# 		echo "$iDIR/volume-mid.png"
# 	elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
# 		echo "$iDIR/volume-high.png"
# 	fi
# }
#
# # Notify
# notify_user() {
# 	notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume : $(get_volume)"
# }
#
# # Increase Volume
# inc_volume() {
# 	pamixer -i 5 && notify_user
# }
#
# # Decrease Volume
# dec_volume() {
# 	pamixer -d 5 && notify_user
# }

#notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "Headset"


#get_source(){
#	source=$(pamixer --list-sources| grep -iP "$mic_name" | grep -Eo '^[0-9]{1,2}' | head -n 1)
#	echo "$source"
#}

