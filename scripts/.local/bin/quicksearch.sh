#!/bin/bash

#search_query=$(zenity --entry --title="Quick Search" --text="Enter search query:")
search_query=$(rofi -dmenu -p "🔎" -theme-str 'window {width: 30%; height: 0%; padding: 10px; border-radius: 10px;} inputbar {children: [prompt, entry];} prompt {background-color: transparent; text-color: inherit; padding: 0 5px;} entry {placeholder: ""; padding: 0px;}' -l 0)
#search_query=$(rofi -dmenu -p "🔎" -theme ~/.config/rofi/custom_search.rasi)
if [ -n "$search_query" ]; then
    encoded_query=$(echo "$search_query" | sed 's/ /%20/g')
    brave-browser --new-window "https://www.google.com/search?q=$encoded_query"
fi
