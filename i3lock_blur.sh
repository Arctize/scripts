#!/bin/bash

TEMP_FILE=`mktemp --suffix '.png'`
RESOLUTION=`xdpyinfo | awk '/dimensions/{print $2}'`

# Save screen timeout
DPMS_VALUES=`xset q | awk 'BEGIN{FPAT="[0-9]+"} /Standby.*Suspend.*Off/{print $1, $2, $3}'`
LOCKSCREEN_TIMEOUT=5

clean_up() {
    rm -f "${TEMP_FILE}"
    xset dpms ${DPMS_VALUES}
}

# Restore dpms settings after process exits
trap clean_up SIGHUP SIGINT SIGTERM

ffmpeg -loglevel quiet -y -s "${RESOLUTION}" -f x11grab -i "${DISPLAY}" -vframes 1 -vf 'gblur=sigma=16' "${TEMP_FILE}"
xset +dpms dpms "${LOCKSCREEN_TIMEOUT}" "${LOCKSCREEN_TIMEOUT}" "${LOCKSCREEN_TIMEOUT}"
i3lock -nei "${TEMP_FILE}"
clean_up
