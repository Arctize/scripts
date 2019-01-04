#!/usr/bin/env bash

# Source generated colors.
source "${HOME}/.cache/wal/colors.sh"

# (re)start dunst with sourced colors
pkill dunst
dunst \
	-lb "$background" \
	-lfr "$background" \
	-lf "$foreground" \
	-nb "$background" \
	-nfr "$background" \
	-nf "$foreground" \
	-bf "$color0" \
	-cfr "$color0" \
	-cb "$color9" &


# force xst to reload .Xresources
pkill -USR1 xst
