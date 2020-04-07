#!/bin/bash

# Script to adjust brightness and show an indicator using dunst

# Call it like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

# Requirements:
#  dunst (obviously)
#  dunstify
#  Papirus icon theme

# Inspired by:
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a


# Lock to assert only a single instance is running
LOCKFILE="/tmp/.`basename $0`.lock"
TIMEOUT=0.1
touch $LOCKFILE
exec {FD}<>$LOCKFILE

if ! flock -x -w $TIMEOUT $FD; then
  echo "Failed to obtain a lock within $TIMEOUT seconds"
  echo "Another instance of `basename $0` is probably running."
  exit 1
fi


# Function to repeat a character (because seq is ugly)
# arg $1: number of repetitions
# arg $2: char to be printed
function repChar {
	for (( i = 0; i < $1; i++ )); do
		printf "$2"
	done
}

function get_volume {
	amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
	amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

# Bar is printed with a fixed width and a padding character ("░")
# so it can be used in a dynamically sized dunst frame and
# is therefore at least somewhat portable between hidpi
# and normal screens
function send_notification {
	volume=`get_volume`

	length=25 # Number characters for the bar
	div=$((100 / $length))
	total=$((100 / $div))
	left=$(($volume / $div))
	right=$(($total - $left))
	bar=$(repChar $left "█")$(repChar $right "░")


	# Send the notification
	dunstify -i audio-volume-high -r 2593 -u normal "$bar"
	#dunstify -i NUL -r 2593 -u normal "  $bar"
}

case $1 in
	up)
		# Set the volume on (if it was muted)
		amixer -D pulse set Master on > /dev/null
		# Up the volume (+ 5%)
		amixer -D pulse sset Master 4%+ > /dev/null
		send_notification
		;;
	down)
		amixer -D pulse set Master on > /dev/null
		amixer -D pulse sset Master 4%- > /dev/null
		send_notification
		;;
	mute)
		# Toggle mute
		amixer -D pulse set Master 1+ toggle > /dev/null
		if is_mute ; then
			dunstify -i audio-volume-muted -r 2593 -u normal "Mute"
		else
			send_notification
		fi
		;;
esac
