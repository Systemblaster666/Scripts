#!/bin/bash

iDIR="$HOME/.config/hypr/mako/icons"

# These are used to find audi sinks. 
# Change the devices and mic. 
speaker="Klipsch"
headset="iFi"
mic_name="Razer"
currentsink="$(pamixer --get-default-sink| grep -oiP "$headset|$speaker" | head -n 1 )" || exit 1
findsink="$(pamixer --get-default-sink| grep -Eo '^[0-9]{1,3}' )"
speakersink="$(pamixer --list-sinks| grep -iP "$speaker" | grep -Eo '^[0-9]{1,3}' | head -n 1 )"
ifisink="$(pamixer --list-sinks| grep -iP "$headset" | grep -Eo '^[0-9]{1,2}' | head -n 1 )"
# Get Volume


get_volume() {
	volume=$(pamixer --get-volume)
	echo "$volume"
}

# Get icons
get_icon() {
	current=$(get_volume)
	if [[ "$current" -eq "0" ]]; then
		echo "$iDIR/volume-mute.png"
	elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
		echo "$iDIR/volume-low.png"
	elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
		echo "$iDIR/volume-mid.png"
	elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
		echo "$iDIR/volume-high.png"
	fi
}

# Notify
notify_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume : $(get_volume)"
}

# Increase Volume
inc_volume() {
	pamixer -i 5 && notify_user
}

# Decrease Volume
dec_volume() {
	pamixer -d 5 && notify_user
}

# Toggle Mute

toggle_mute() {
	if [ "$(pamixer --get-mute)" == "false" ]; then
		pamixer -t --source $findsink && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-mute.png" "Volume Switched OFF"
	elif [ "$(pamixer --get-mute)" == "true" ]; then
		pamixer -t --source $findsink && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume Switched ON"
	fi
}

get_source(){
	source=$(pamixer --list-sources| grep -iP "$mic_name" | grep -Eo '^[0-9]{1,2}' | head -n 1)
	echo "$source" 
}
# Toggle Mic   "$iDIR/microphone-mute.png"   "$iDIR/microphone.png"
toggle_mic() {
	currentsource=$(get_source)
	if [ "$(pamixer --source $currentsource --get-mute)" == "false" ]; then
		pamixer -m --source $currentsource && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-mute.png" "Mic/Audio OFF"
	elif [ "$(pamixer --source $currentsource --get-mute)" == "true" ]; then
		pamixer -u --source $currentsource && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Mic/Audio ON" 
	fi
}

toggle_sink() {
	if [ "$currentsink" == "$speaker" ]; then
		ifi="$(pactl set-default-sink $ifisink)"
		$ifi
		notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/audio-speakers.svg" "Speaker" 
	elif [ "$currentsink" == "$headset" ]; then
		speakers="$(pactl set-default-sink $speakersink)"
		$speakers
		notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/audio-headphones.svg" "Headset" 
	fi
}


# Execute accordingly
if [[ "$1" == "--get" ]]; then
	get_volume
elif [[ "$1" == "--inc" ]]; then
	inc_volume
elif [[ "$1" == "--dec" ]]; then
	dec_volume
elif [[ "$1" == "--toggle" ]]; then
	toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
	toggle_mic
elif [[ "$1" == "--get-icon" ]]; then
	get_icon
elif [[ "$1" == "--toggle_mic" ]]; then
	toggle_mic
	$(pamixer -t)
elif [[ "$1" == "--toggle_sink" ]]; then
	toggle_sink
else
	get_volume
fi
