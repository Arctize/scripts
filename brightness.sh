#!/bin/bash

# Script to adjust brightness and show an indicator using dunst

# Call it like this:
# $./brightness.sh up
# $./brightness.sh down

# Requirements:
#  dunst (obviously)
#  dunstify
#  xbacklight
#  Papirus icon theme

# Inspired by:
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a


# Function to repeat a character (because seq is ugly)
# arg $1: number of repetitions
# arg $2: char to be printed
function repChar {
	for (( i = 0; i < $1; i++ )); do
		printf "$2"
	done
}

# Bar is printed with a fixed width and a padding character ("░")
# so it can be used in a dynamically sized dunst frame and
# is therefore at least somewhat portable between hidpi
# and normal screens
function send_notification {
	bl=$(xbacklight -get | cut -d '.' -f 1)

	length=25 # Number characters for the bar
	div=$((100 / $length))
	total=$((100 / $div))
	left=$(($bl / $div))
	right=$(($total - $left))
	bar=$(repChar $left "█")$(repChar $right "░")

	# Send the notification
	dunstify -i display-brightness-symbolic -r 2594 -u normal "$bar"
}

case $1 in
	up)
		xbacklight +8
		send_notification
		;;
	down)
		xbacklight -8
		send_notification
		;;
esac
