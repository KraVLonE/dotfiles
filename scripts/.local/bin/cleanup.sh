#!/bin/bash

set -euo pipefail

echo "========================================"
echo " Debian Deep Clean"
echo "========================================"

# ----------------------------------------

# Helpers

# ----------------------------------------

print_section() {
echo
echo "----------------------------------------"
echo "$1"
echo "----------------------------------------"
}

human() {
numfmt --to=iec --suffix=B "$1"
}

# ----------------------------------------

# Pre-cleanup measurements

# ----------------------------------------

BEFORE_BYTES=$(df --output=avail -B1 / | tail -n1)

print_section "Disk Usage Before Cleanup"

echo "Available Space: $(human "$BEFORE_BYTES")"
echo
df -h /

# ----------------------------------------

# APT Cleanup

# ----------------------------------------

print_section "APT Cleanup"

sudo apt clean
sudo apt autoremove --purge -y

# Remove orphaned package configs

dpkg -l | awk '/^rc/ {print $2}' | xargs -r sudo dpkg --purge

# ----------------------------------------

# Log Cleanup

# ----------------------------------------

print_section "System Logs"

# Keep only 100 MB of journal logs

sudo journalctl --vacuum-size=100M

# Truncate runaway logs larger than 500 MB

sudo find /var/log -type f -name "*.log" -size +500M -exec truncate -s 0 {} \;

# ----------------------------------------

# VS Code

# ----------------------------------------

print_section "VS Code"

rm -rf ~/.cache/vscode-cpptools/ipch/* 2>/dev/null || true
rm -rf ~/.config/Code/CachedExtensionVSIXs/* 2>/dev/null || true

# ----------------------------------------

# Browser Caches

# ----------------------------------------

print_section "Browser Caches"

# Firefox

rm -rf ~/.cache/mozilla/firefox/*/*.default*/cache2/* 2>/dev/null || true

# Brave

rm -rf ~/.cache/BraveSoftware/* 2>/dev/null || true

# ----------------------------------------

# Discord

# ----------------------------------------

print_section "Discord"

rm -rf ~/.config/discord/Cache/* 2>/dev/null || true
rm -rf ~/.config/discord/Code\ Cache/* 2>/dev/null || true
rm -rf ~/.config/discord/GPUCache/* 2>/dev/null || true

# ----------------------------------------

# Stremio

# ----------------------------------------

print_section "Stremio"

rm -rf ~/.stremio-server/stremio-cache/* 2>/dev/null || true

# ----------------------------------------

# Development Tool Caches

# ----------------------------------------

print_section "Development Caches"

# Puppeteer

rm -rf ~/.cache/puppeteer/* 2>/dev/null || true

# Playwright

rm -rf ~/.cache/ms-playwright/* 2>/dev/null || true

# ----------------------------------------

# Desktop Caches

# ----------------------------------------

print_section "Desktop Caches"

rm -rf ~/.cache/thumbnails/* 2>/dev/null || true

# Optional: clear all remaining user cache

# Uncomment if desired

# rm -rf ~/.cache/*

# ----------------------------------------

# Trash

# ----------------------------------------

print_section "Trash"

rm -rf ~/.local/share/Trash/files/* 2>/dev/null || true
rm -rf ~/.local/share/Trash/info/* 2>/dev/null || true

# ----------------------------------------

# Results

# ----------------------------------------

AFTER_BYTES=$(df --output=avail -B1 / | tail -n1)
FREED_BYTES=$((AFTER_BYTES - BEFORE_BYTES))

print_section "Cleanup Complete"

echo "Space Freed : $(human "$FREED_BYTES")"
echo "Available   : $(human "$AFTER_BYTES")"

echo
df -h /

# ----------------------------------------

# Warning Report

# ----------------------------------------

USAGE=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

if [ "$USAGE" -ge 90 ]; then
print_section "Disk Still Above 90%"

```
echo "Largest files on the system:"
sudo find / -type f -size +500M 2>/dev/null \
    | xargs -r ls -lh \
    | sort -k5 -hr \
    | head -20
```

fi
