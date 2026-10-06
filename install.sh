#!/usr/bin/env bash

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

echo "=== Dotfiles & Scripts Installer ==="

# 1. Check for GNU Stow
if ! command -v stow &> /dev/null; then
    echo "GNU Stow is not installed."
    echo "Installing GNU Stow via apt..."
    sudo apt update && sudo apt install -y stow
fi

# 2. Ensure target directories exist
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/dotfiles"

# 3. Handle secrets and configs templates
if [ ! -f "$HOME/.config/dotfiles/secrets.env" ]; then
    if [ -f "$REPO_DIR/.env.example" ]; then
        echo "Creating initial ~/.config/dotfiles/secrets.env..."
        cp "$REPO_DIR/.env.example" "$HOME/.config/dotfiles/secrets.env"
        chmod 600 "$HOME/.config/dotfiles/secrets.env"
    fi
fi

if [ ! -f "$HOME/.config/dotfiles/git-accounts.conf" ]; then
    if [ -f "$REPO_DIR/git-accounts.conf.example" ]; then
        echo "Creating initial ~/.config/dotfiles/git-accounts.conf..."
        cp "$REPO_DIR/git-accounts.conf.example" "$HOME/.config/dotfiles/git-accounts.conf"
        chmod 600 "$HOME/.config/dotfiles/git-accounts.conf"
    fi
fi

if [ ! -f "$HOME/.bash_aliases.local" ]; then
    if [ -f "$REPO_DIR/bash/.bash_aliases.local.example" ]; then
        echo "Creating initial ~/.bash_aliases.local..."
        cp "$REPO_DIR/bash/.bash_aliases.local.example" "$HOME/.bash_aliases.local"
        chmod 600 "$HOME/.bash_aliases.local"
    fi
fi

# 4. Backup existing target files if they are regular files (not symlinks)
backup_if_regular_file() {
    local target="$HOME/$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.backup.$(date +%s)"
        echo "Backing up existing $target -> $backup"
        mv "$target" "$backup"
    fi
}

backup_if_regular_file ".bashrc"
backup_if_regular_file ".bash_aliases"
backup_if_regular_file ".gitconfig"

# 5. Run GNU Stow
echo "Stowing packages (bash, git, scripts)..."
stow -v -R -t "$HOME" bash git scripts

echo ""
echo "✅ All dotfiles and scripts have been successfully stowed into $HOME!"
echo "   - Scripts symlinked into: ~/.local/bin"
echo "   - Bash configs symlinked into: ~/.bashrc and ~/.bash_aliases"
echo "   - Git config symlinked into: ~/.gitconfig"
echo "   - Secrets file: ~/.config/dotfiles/secrets.env"
echo "   - Git accounts: ~/.config/dotfiles/git-accounts.conf"
echo "   - Private aliases: ~/.bash_aliases.local"
echo ""
echo "Run 'source ~/.bashrc' or restart your terminal to reload."

