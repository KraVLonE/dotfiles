#!/bin/bash

# Function to display help information
function help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  cf [c|p]    Open Codeforces in Brave and VS Code for contests (-c) or practice (-p)."
    echo "  cc [c|p]    Open Codechef in Brave and VS Code for contests (-c) or practice (-p)."
    echo "  lc [c|p]    Open LeetCode in Brave and VS Code for contests (-c) or practice (-p)."
    echo "  ac [c|p]    Open AtCoder in Brave and VS Code for contests (-c) or practice (-p)."
    echo "  cs [c|p]    Open CSES in Brave and VS Code for contests (-c) or practice (-p)."
    echo "  -h          Opens this Page"
    echo
    echo "Example usage:"
    echo "  $0 cf c       # Open Codeforces for contests"
    echo "  $0 cc p       # Open Codechef for practice"
    echo "  $0 lc c       # Open LeetCode for contests"
    echo
}

# Function to display error messages in red
function error() {
    echo -e "\033[31m$1\033[0m" # Red color
}

open_brave() {
    local profile="Profile 2"
    local url="$1"
    echo "Opening Brave Browser..."
    existing_windows=$(wmctrl -lx | grep "Brave" | awk '{print $1}')
    
    brave-browser --profile-directory="$profile" "$url" &
    
    BRAVE_PID=$!
    sleep 3
    new_windows=$(wmctrl -lx | grep "Brave" | awk '{print $1}')
    BRAVE_WINDOW_ID=""
    for window in $new_windows; do
        if ! echo "$existing_windows" | grep -q "$window"; then
            BRAVE_WINDOW_ID=$window
            break
        fi
    done

    if [ -z "$BRAVE_WINDOW_ID" ]; then
        error "Failed to find the Brave window ID"
        exit 1
    fi

    wmctrl -i -r "$BRAVE_WINDOW_ID" -t 3
}

open_vscode() {
    local dir="$1"
    echo "Opening Visual Studio Code..."
    code "$dir" &
    wmctrl -r "Visual Studio Code" -t 3
}

switch_to_workspace() {
    echo "Switching to workspace 4..."
    wmctrl -s 3
}

echo "Initializing Competitive Programming Environment..."

while (( "$#" )); do
    case "$1" in
        cf)
            if [ "$2" == "c" ]; then
                open_brave "https://codeforces.com/contests"
                open_vscode "$HOME/Documents/Programs_Projects/CP/Codeforces/contest"
            elif [ "$2" == "p" ]; then
                open_brave "https://codeforces.com/problemset"
                open_vscode "$HOME/Documents/Programs_Projects/CP/Codeforces/practice"
            else
                error "Invalid option for cf. Use -c for contest or -p for practice."
                exit 1
            fi
            shift 2
            ;;
        cc)
            if [ "$2" == "c" ]; then
                open_brave "https://www.codechef.com/contests"
                open_vscode "$HOME/Documents/Programs_Projects/CP/Codechef/contest"
            elif [ "$2" == "p" ]; then
                open_brave "https://www.codechef.com/practice-old"
                open_vscode "$HOME/Documents/Programs_Projects/CP/Codechef/practice"
            else
                error "Invalid option for cc. Use -c for contest or -p for practice."
                exit 1
            fi
            shift 2
            ;;
        lc)
            if [ "$2" == "c" ]; then
                open_brave "https://leetcode.com/contest"
               # open_vscode "$HOME/Documents/Programs_Projects/CP/Leetcode/contest"
            elif [ "$2" == "p" ]; then
                open_brave "https://leetcode.com/problemset/all"
               # open_vscode "$HOME/Documents/Programs_Projects/CP/Leetcode/practice"
            else
                error "Invalid option for lc. Use -c for contest or -p for practice."
                exit 1
            fi
            shift 2
            ;;
        ac)
            if [ "$2" == "c" ]; then
                open_brave "https://atcoder.jp/contests"
                open_vscode "$HOME/Documents/Programs_Projects/CP/Atcoder/contest"
            elif [ "$2" == "p" ]; then
                open_brave "https://atcoder.jp/practice"
                open_vscode "$HOME/Documents/Programs_Projects/CP/Atcoder/practice"
            else
                error "Invalid option for ac. Use -c for contest or -p for practice."
                exit 1
            fi
            shift 2
            ;;
        cs)
            if [ "$2" == "c" ]; then
                open_brave "https://cses.fi/contests"
                open_vscode "$HOME/Documents/Programs_Projects/CP/CSES/contest"
            elif [ "$2" == "p" ]; then
                open_brave "https://cses.fi/problemset"
                open_vscode "$HOME/Documents/Programs_Projects/CP/CSES/practice"
            else
                error "Invalid option for cs. Use -c for contest or -p for practice."
                exit 1
            fi
            shift 2
            ;;
        -h)
            help
            exit 1
            ;;
        *)
            error "Error: Invalid option: $1"
            help
            exit 1
            ;;
    esac
done

switch_to_workspace

echo "Environment setup complete. Happy coding!"

