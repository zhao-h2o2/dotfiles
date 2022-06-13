#!/bin/bash

start() {
  start_usage() { echo "start: [-p <arg>] [-r]" 1>&2; exit; }

  local OPTIND opt restart program
  while getopts ":rp:" opt; do case "${opt}" in
    "p") program=${OPTARG} && echo $program;;
    "r") restart="1" && echo $restart;;
    *) start_usage;;
  esac done
  shift $((OPTIND -1))

  if [ ! $program ]; then
    program=$1
  fi

  if [ $(pidof -s $program) ]; then
    if [ $restart ]; then
      pidof -s "$program" && killall -q "$program" && sleep 1
      setsid -f "$1" "$2" || setsid -f "$1"
    fi
  else
    setsid -f "$1" "$2" || setsid -f "$1"
  fi
} >/dev/null 2>&1

sh ~/.fehbg
#feh --bg-fill --no-fehbg ~/Pictures/wallpapers/wallhaven-3z2med.jpg &
start dunst
start -r picom --experimental-backends
start -p polybar ~/.config/polybar/launch.sh

notify-send "$DESKTOP_SESSION started" &
sleep 5

start /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
# start nm-applet
# start volumeicon
start xfce4-power-manager
start barrier
start clipit
start optimus-manager-qt
start fcitx5
start syncthingtray --wait
