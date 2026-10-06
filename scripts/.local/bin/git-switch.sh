#!/bin/bash

# Load accounts configuration
CONFIG_FILE="$HOME/.config/dotfiles/git-accounts.conf"
if [ -f "$CONFIG_FILE" ]; then
    # shellcheck disable=SC1090
    source "$CONFIG_FILE"
else
    echo "❌ Config file not found: $CONFIG_FILE"
    echo "Please copy git-accounts.conf.example to ~/.config/dotfiles/git-accounts.conf"
    exit 1
fi

# Function to switch Git account
switch_git_account() {
    local account=$1
    if [[ -z "${GIT_ACCOUNTS[$account]}" ]]; then
        echo "❌ Account '$account' not found!"
        echo "Available accounts: ${!GIT_ACCOUNTS[@]}"
        exit 1
    fi

    # Extract user details
    IFS=' ' read -r name email ssh_key <<< "${GIT_ACCOUNTS[$account]}"

    # Set Git user details
    git config --local user.name "$name"
    git config --local user.email "$email"

    # Set SSH key
    ssh-add -D  # Remove all SSH identities
    ssh-add "$ssh_key"

    echo "✅ Switched to Git account: $account"
    echo "   - User: $name"
    echo "   - Email: $email"
    echo "   - SSH Key: $ssh_key"
}

# Check input
if [[ $# -ne 1 ]]; then
    echo "Usage: git-switch <account>"
    echo "Available accounts: ${!GIT_ACCOUNTS[@]}"
    exit 1
fi

switch_git_account "$1"
