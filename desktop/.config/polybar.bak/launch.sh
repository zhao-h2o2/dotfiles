#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

monitor_ex=$(xrandr -q | grep -w "connected" | awk '{print $1}' | grep "HDMI")
monitor_in=$(xrandr -q | grep -w "connected" | awk '{print $1}' | grep "eDP")

if [ $monitor_ex ];then
  MONITOR=$monitor_ex polybar -q main-$DESKTOP_SESSION -r -c "$DIR"/config.ini & >>/tmp/polybar1.log 2>&1 & disown
  MONITOR=$monitor_in polybar -q extra-$DESKTOP_SESSION -r -c "$DIR"/config.ini & >>/tmp/polybar2.log 2>&1 & disown
else
  MONITOR=$monitor_in polybar -q main-$DESKTOP_SESSION -r -c "$DIR"/config.ini & >>/tmp/polybar1.log 2>&1 & disown
fi

unset monitor_ex
unset monitor_in
