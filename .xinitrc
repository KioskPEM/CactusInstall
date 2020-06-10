#!/bin/sh
xset -dpms
xset s off
xset s noblank

width=1024
height=768
url="http://127.0.0.1:8080/public/index.php?lang=fr&path=welcome"

unclutter &
chromium \
	--no-first-run \
	--start-fullscreen \
	--incognito \
	--noerdialogs \
	--disable \
	--disable-translate \
	--disable-infobars \
	--disable-suggestions-service \
	--disable-save-password-bubble \
	--disable-features=TranslateUI \
	--fast \
	--fast-start \
	--disk-cache=/dev/null \
	--window-position=0,0 \
	--window-size=$width,$height \
	--kiosk $url
