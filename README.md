# Personal Dotfiles & Daily Drive Scripts

A modular dotfiles and scripts repository managed with **GNU Stow** on Debian.

## Directory Structure

```text
.
├── bash/                       # Bash configuration package
│   ├── .bashrc
│   └── .bash_aliases
│
├── git/                        # Git configuration package
│   └── .gitconfig
│
├── scripts/                    # Daily driver scripts package
│   └── .local/
│       └── bin/                # Symlinked directly into ~/.local/bin/
│           ├── activatenv.sh
│           ├── autoupdate.sh
│           ├── cleanup.sh
│           ├── convertCookies.py
│           ├── cpsetup.sh
│           ├── createnv.sh
│           ├── git-switch.sh
│           ├── installerPs1.sh
│           ├── mirrorsetup.sh
│           ├── mkps1.sh
│           ├── openaternos.py
│           ├── PS1Designs.sh
│           ├── quicksearch.sh
│           ├── setupresumeagent.sh
│           ├── test-cpsetup.sh
│           ├── test.sh
│           └── vpntoggle.sh
│
├── .env.example                # Example template for local credentials
├── git-accounts.conf.example   # Example template for git-switch accounts
├── .gitignore                  # Ignores secrets, caches, and backups
├── install.sh                  # Setup script that installs stow and links configs
└── README.md
```

---

## Quick Installation

1. Move or clone this repository into `~/dotfiles`:
   ```bash
   # If moving from Documents/Scripts:
   mv ~/Documents/Scripts ~/dotfiles
   cd ~/dotfiles
   ```

2. Run the automated installer:
   ```bash
   ./install.sh
   ```

3. Reload your shell:
   ```bash
   source ~/.bashrc
   ```

---

## How It Works

This setup uses **GNU Stow** to manage symlinks into your `$HOME` directory:
* `bash/` mirrors into `$HOME/` (`~/.bashrc`, `~/.bash_aliases`)
* `git/` mirrors into `$HOME/` (`~/.gitconfig`)
* `scripts/` mirrors into `$HOME/.local/bin/` (all scripts become directly executable in any terminal without typing paths)

Because symlinks point to files inside this repository:
- Editing `~/.bashrc` edits `bash/.bashrc` directly.
- Adding a script inside `scripts/.local/bin/` automatically makes it available system-wide after running `stow -R scripts`.
- Running `git status` here shows all your changes ready to commit and push.

---

## Secrets & Accounts Management

Sensitive credentials and personal identity details are **never committed to Git**:
* **VPN / Script Passwords:** Read from `~/.config/dotfiles/secrets.env` (copy from `.env.example`).
* **Git Switch Accounts:** Read from `~/.config/dotfiles/git-accounts.conf` (copy from `git-accounts.conf.example`).

To set up:
```bash
cp .env.example ~/.config/dotfiles/secrets.env
chmod 600 ~/.config/dotfiles/secrets.env

cp git-accounts.conf.example ~/.config/dotfiles/git-accounts.conf
chmod 600 ~/.config/dotfiles/git-accounts.conf
```

---

## Adding More Dotfiles (e.g. Hyprland, Neovim, Waybar)

To manage another tool with Stow:
1. Create a package directory mirroring `$HOME`:
   ```bash
   mkdir -p hyprland/.config/hypr
   cp ~/.config/hypr/hyprland.conf hyprland/.config/hypr/
   ```
2. Stow the package:
   ```bash
   stow hyprland
   ```

