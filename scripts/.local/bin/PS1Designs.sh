#!/bin/bash
# Filename: bash_prompt_designs.sh
# Collection of high-quality PS1 prompt designs for Bash
# Add your preferred design to your ~/.bashrc file

# Make sure necessary packages are installed
ensure_dependencies() {
  if ! command -v tput &> /dev/null; then
    echo "Installing ncurses for terminal control..."
    sudo apt-get update && sudo apt-get install -y ncurses-bin
  fi
}

# Design 1: Minimalist with git status
setup_minimalist_git_prompt() {
  # First check if git is installed
  if ! command -v git &> /dev/null; then
    echo "Git is not installed. Some prompt features will be disabled."
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    return
  fi

  # Git branch function
  parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }

  # Minimalist design with git branch info
  PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\]\$ '
  
  echo "Minimalist Git prompt enabled!"
}

# Design 2: Professional two-line prompt
setup_professional_prompt() {
  # Using tput for more compatibility
  reset=$(tput sgr0)
  bold=$(tput bold)
  green=$(tput setaf 2)
  blue=$(tput setaf 4)
  cyan=$(tput setaf 6)
  white=$(tput setaf 7)
  
  # Two-line prompt with time, user, host, and directory
  PS1="\[${bold}${green}\]┌─[\[${cyan}\]\t\[${reset}${bold}${green}\]]─[\[${cyan}\]\u@\h\[${reset}${bold}${green}\]]─[\[${cyan}\]\w\[${reset}${bold}${green}\]]\n\[${bold}${green}\]└──╼ \[${white}\]$ \[${reset}\]"
  
  echo "Professional two-line prompt enabled!"
}

# Design 3: Performance-oriented prompt with exit status
setup_performance_prompt() {
  # Function to show exit status
  exit_status() {
    local status="$?"
    if [ $status -ne 0 ]; then
      echo -e "\[\033[31m\]✘ $status\[\033[00m\] "
    else
      echo -e "\[\033[32m\]✓\[\033[00m\] "
    fi
  }
  
  # Performance oriented with exit status
  PS1='$(exit_status)\[\033[38;5;240m\]\t\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\$ '
  
  echo "Performance-oriented prompt with exit status enabled!"
}

# Design 4: Powerline-style prompt
setup_powerline_prompt() {
  # Check if powerline fonts are likely installed
  if [ "$(fc-list | grep -i powerline | wc -l)" -eq 0 ]; then
    echo "Warning: Powerline fonts may not be installed. The prompt might not display correctly."
    echo "Install them with: sudo apt-get install fonts-powerline"
  fi
  
  # Define powerline segments and colors
  prompt_segment() {
    local bg fg
    [[ -n $1 ]] && bg="\[$(tput setab $1)\]" || bg="\[$(tput setab 0)\]"
    [[ -n $2 ]] && fg="\[$(tput setaf $2)\]" || fg="\[$(tput setaf 7)\]"
    
    echo -n "${bg}${fg} $3 "
  }
  
  # Create powerline-style prompt
  PS1=""
  PS1+="$(prompt_segment 240 15 '\u@\h')"
  PS1+="$(prompt_segment 26 15 '\w')"
  PS1+="\[$(tput sgr0)\]\[$(tput setaf 26)\]\[$(tput sgr0)\] "
  
  echo "Powerline-style prompt enabled!"
}

# Design 5: Git-focused developer prompt
setup_developer_prompt() {
  # Check for git
  if ! command -v git &> /dev/null; then
    echo "Git is not installed. Developer prompt will have limited functionality."
  fi

  # Git status indicators
  git_status() {
    local status modified untracked ahead behind
    status=$(git status 2>/dev/null)
    
    if [[ $? -ne 0 ]]; then
      echo ""
      return
    fi
    
    # Get branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always 2>/dev/null)
    
    # Check status
    modified=$(echo "$status" | grep "modified:" | wc -l)
    untracked=$(echo "$status" | grep "Untracked files" | wc -l)
    ahead=$(echo "$status" | grep "Your branch is ahead of" | wc -l)
    behind=$(echo "$status" | grep "Your branch is behind" | wc -l)
    
    # Build status string
    local status_indicators=""
    [[ $modified -gt 0 ]] && status_indicators+="*"
    [[ $untracked -gt 0 ]] && status_indicators+="+"
    [[ $ahead -gt 0 ]] && status_indicators+="↑"
    [[ $behind -gt 0 ]] && status_indicators+="↓"
    
    echo " [${branch}${status_indicators}]"
  }
  
  # Developer prompt with git status
  PS1='\[\033[38;5;39m\]\u\[\033[00m\] at \[\033[38;5;208m\]\h\[\033[00m\] in \[\033[38;5;76m\]\w\[\033[00m\]\[\033[38;5;196m\]$(git_status)\[\033[00m\]\n\$ '
  
  echo "Developer-focused git prompt enabled!"
}

# Design 6: Server admin prompt with load information
setup_server_admin_prompt() {
  # Function to get system load
  get_load() {
    local load=$(cat /proc/loadavg | awk '{print $1}')
    local cores=$(grep -c '^processor' /proc/cpuinfo)
    local load_percent=$(echo "$load * 100 / $cores" | bc)
    
    if [[ $load_percent -lt 30 ]]; then
      echo -e "\[\033[32m\]$load\[\033[00m\]"
    elif [[ $load_percent -lt 70 ]]; then
      echo -e "\[\033[33m\]$load\[\033[00m\]"
    else
      echo -e "\[\033[31m\]$load\[\033[00m\]"
    fi
  }
  
  # Server admin prompt with load info
  PS1='\[\033[01;31m\][\t] \u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] [load: $(get_load)]\$ '
  
  echo "Server admin prompt with system load enabled!"
}

# Design 7: Elegant and clean prompt
setup_elegant_prompt() {
  # Elegant design with subtle colors
  PS1='\[\033[38;5;242m\]┌──[\[\033[38;5;66m\]\u\[\033[38;5;242m\]]─[\[\033[38;5;37m\]\w\[\033[38;5;242m\]]\n└─╼ \[\033[38;5;248m\]\$ \[\033[00m\]'
  
  echo "Elegant clean prompt enabled!"
}

# Design 8: Colorful dynamically-sized prompt
setup_colorful_prompt() {
  # Generate a line of appropriate length
  line() {
    local columns=$(tput cols)
    local line=""
    for i in $(seq 1 $columns); do
      line+=─
    done
    echo $line
  }
  
  # Colorful prompt with dynamic sizing
  PS1='\[\033[38;5;196m\]$(line)\n\[\033[38;5;208m\]\u\[\033[38;5;242m\]@\[\033[38;5;33m\]\h \[\033[38;5;76m\]\w\[\033[00m\]\n\$ '
  
  echo "Colorful dynamically-sized prompt enabled!"
}

# Design 9: Compact and informative prompt
setup_compact_prompt() {
  # Compact but informative design
  PS1='\[\033[38;5;240m\][\t] \[\033[38;5;35m\]\u\[\033[38;5;242m\]@\[\033[38;5;27m\]\h\[\033[38;5;242m\]:\[\033[38;5;214m\]\w\[\033[00m\]\$ '
  
  echo "Compact informative prompt enabled!"
}

# Design 10: Modern emoji prompt
setup_emoji_prompt() {
  # Modern prompt with emoji indicators
  PS1='\[\033[01;37m\]🌈 \u\[\033[00m\] at \[\033[01;33m\]💻 \h\[\033[00m\] in \[\033[01;36m\]📁 \w\[\033[00m\]\n\[\033[01;37m\]➤ \[\033[00m\]'
  
  echo "Modern emoji prompt enabled!"
}

# Main function to set up your preferred prompt
setup_prompt() {
  ensure_dependencies
  
  # Uncomment your preferred prompt design:
  
  # setup_minimalist_git_prompt
  # setup_professional_prompt
  # setup_performance_prompt
  # setup_powerline_prompt
  # setup_developer_prompt
  # setup_server_admin_prompt
  # setup_elegant_prompt
  # setup_colorful_prompt
  # setup_compact_prompt
  # setup_emoji_prompt
  
  # Or set prompt directly
  # PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  
  # Remember to add this to your ~/.bashrc
  echo ""
  echo "To make this prompt permanent, copy your preferred setup function"
  echo "and the PS1 assignment to your ~/.bashrc file"
}

# Run setup (comment this line when adding to .bashrc)
# setup_prompt

