#!/usr/bin/env bash

# Set key repeat rate
xset r rate 200 50

# Map Caps to Ctrl
setxkbmap -option 'caps:ctrl_modifier'

# Compile and set mwb-layout
setxkbmap -I ~/.xkb mwb -print | xkbcomp -I$HOME/.xkb - $DISPLAY 2>/dev/null

# Use Caps as ESC and Ctrl modifier simultaneously
xcape -e '#66=Escape'

