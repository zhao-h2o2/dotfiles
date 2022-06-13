#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Files and Directories
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

## Launch Polybar with selected style
launch_bar() {
	# Terminate already running bar instances
	killall -q polybar
	
	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
	
	monitor_ex=$(xrandr -q | grep -w "connected" | awk '{print $1}' | grep "HDMI")
	monitor_in=$(xrandr -q | grep -w "connected" | awk '{print $1}' | grep "eDP")
	
	STYLE="default"

  if [ $DESKTOP_SESSION = "dwm" ]; then
  	DE="-dwm"
  fi

	if [ $monitor_ex ];then
	  MONITOR=$monitor_ex polybar -q main$DE -r -c "$DIR"/"$STYLE"/config.ini & >>/tmp/polybar1.log 2>&1 & disown
	  MONITOR=$monitor_in polybar -q extra$DE -r -c "$DIR"/"$STYLE"/config.ini & >>/tmp/polybar2.log 2>&1 & disown
	else
	  MONITOR=$monitor_in polybar -q main$DE -r -c "$DIR"/"$STYLE"/config.ini & >>/tmp/polybar1.log 2>&1 & disown
	fi
	
	unset monitor_ex
	unset monitor_in
}

launch_bar
