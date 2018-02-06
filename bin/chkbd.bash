#! /usr/bin/env bash

current=$(/usr/bin/setxkbmap -query | grep layout | tail -c 3)
if [ "$current" == "gb" ]; then
    /usr/bin/setxkbmap br
else
    /usr/bin/setxkbmap gb
fi

