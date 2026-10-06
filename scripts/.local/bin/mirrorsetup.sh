#!/bin/bash

# Get the IDs of the input devices
MOUSE_ID=10
KEYBOARD_ID=12

# Define the list of workspaces
WORKSPACES=(0 1 2 3 4)

# Function to switch to a specific workspace
switch_to_workspace() {
    wmctrl -s $1
}

# Function to mirror mouse events
mirror_mouse_event() {
    local event=$1
    local x=$2
    local y=$3
    local button=$4
    for ws in "${WORKSPACES[@]}"; do
        switch_to_workspace $ws
        if [ "$event" = "motion" ]; then
            xdotool mousemove $x $y
        elif [ "$event" = "press" ]; then
            xdotool mousedown $button
        elif [ "$event" = "release" ]; then
            xdotool mouseup $button
        fi
    done
}

# Function to mirror keyboard events
mirror_keyboard_event() {
    local event=$1
    local keycode=$2
    for ws in "${WORKSPACES[@]}"; do
        switch_to_workspace $ws
        if [ "$event" = "press" ]; then
            xdotool keydown $keycode
        elif [ "$event" = "release" ]; then
            xdotool keyup $keycode
        fi
    done
}

# Listen for mouse events
xinput test $MOUSE_ID | while read line; do
    if [[ $line =~ "motion" ]]; then
        coords=($(echo $line | grep -oP 'root_x=\K\d+|root_y=\K\d+'))
        mirror_mouse_event "motion" ${coords[0]} ${coords[1]}
    elif [[ $line =~ "button press" ]]; then
        button=$(echo $line | grep -oP 'button \K\d+')
        mirror_mouse_event "press" 0 0 $button
    elif [[ $line =~ "button release" ]]; then
        button=$(echo $line | grep -oP 'button \K\d+')
        mirror_mouse_event "release" 0 0 $button
    fi
done &

# Listen for keyboard events
xinput test $KEYBOARD_ID | while read line; do
    if [[ $line =~ "key press" ]]; then
        keycode=$(echo $line | grep -oP 'key \K\d+')
        mirror_keyboard_event "press" $keycode
    elif [[ $line =~ "key release" ]]; then
        keycode=$(echo $line | grep -oP 'key \K\d+')
        mirror_keyboard_event "release" $keycode
    fi
done
