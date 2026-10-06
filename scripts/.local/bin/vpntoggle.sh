#!/bin/bash

# Load credentials from local secrets file or environment
SECRETS_FILE="$HOME/.config/dotfiles/secrets.env"
if [ -f "$SECRETS_FILE" ]; then
    # shellcheck disable=SC1090
    source "$SECRETS_FILE"
fi

USERNAME="${NORDVPN_USER:-}"
PASSWORD="${NORDVPN_PASS:-}"

if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
    echo "Error: NordVPN credentials missing. Please set NORDVPN_USER and NORDVPN_PASS in $SECRETS_FILE"
    exit 1
fi

# Function to connect to NordVPN
connect_to_vpn() {
    echo "Connecting to NordVPN..."
    nordvpn login -u "$USERNAME" -p "$PASSWORD"
    nordvpn connect
}

# Function to disconnect from NordVPN
disconnect_from_vpn() {
    echo "Disconnecting from NordVPN..."
    nordvpn disconnect
}

# Main function to toggle VPN connection
toggle_vpn() {
    # Check if NordVPN is currently connected
    if nordvpn status | grep -q "Status: Connected"; then
        disconnect_from_vpn
    else
        connect_to_vpn
    fi
}

# Check if NordVPN is installed
if ! command -v nordvpn &> /dev/null; then
    echo "Error: NordVPN CLI is not installed."
    exit 1
fi

# Main script logic
case "$1" in
    "connect")
        connect_to_vpn
        ;;
    "disconnect")
        disconnect_from_vpn
        ;;
    *)
        toggle_vpn
        ;;
esac

