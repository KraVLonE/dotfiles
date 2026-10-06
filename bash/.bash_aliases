alias minecraft="java -jar $HOME/Minecraft/TLauncher.v10/TLauncher.jar"
alias grep='grep --color=auto'
alias minecraft-server="cd ~/Minecraft/server && java -Xmx3024M -Xms3024M -jar server.jar nogui"

alias fm="alacritty -e ranger"
alias sai="sudo apt install"
alias sacp="sudo apt-cache policy"
alias sdi="sudo dpkg --install" 
alias sar="sudo apt remove"
alias sas="sudo apt search"
alias lsi="exa --icons"
alias cats='bat --style=plain'

# Configs
alias aliasconf="micro ~/.bash_aliases"
alias hyperconf="sudo nano ~/.config/hypr/hyprland.conf"
alias waybarconf="sudo nano ~/.config/waybar/config"

# Navigation 
alias gtctf="cd $HOME/Documents/Programs_Projects/CTF"
alias gtcp="cd $HOME/Documents/Programs_Projects/CP"
alias gtsh="cd $HOME/dotfiles"
alias gtpj="cd $HOME/Documents/Programs_Projects/Projects"
alias gtvenv="cd $HOME/.venvs/"
alias gtservice="cd /etc/systemd/system/"

# Quick Tools
alias fix-audio="systemctl --user restart pipewire; systemctl --user restart wireplumber"
alias run-resumeagent="python agent/agent.py --jd inputs/example_jd.txt --compile"
alias kill-stremio="pkill -f stremio"

# Scripts (located in ~/.local/bin via stow)
alias activatenv="activatenv.sh"
alias pyenv="createnv.sh"
alias qs="quicksearch.sh"
alias update="autoupdate.sh"
alias setresumeagent="source setupresumeagent.sh"

# Load local untracked aliases (for server logins, private keys, etc.)
if [ -f "$HOME/.bash_aliases.local" ]; then
    . "$HOME/.bash_aliases.local"
fi
