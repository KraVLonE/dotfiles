#!/bin/bash
# Filename: install_fancy_prompt.sh
# A script to easily install fancy prompts to your .bashrc

# Install function
install_prompt() {
  local choice=$1
  local bashrc="$HOME/.bashrc"
  local backup="$HOME/.bashrc.backup.$(date +%s)"
  
  # Make a backup
  cp "$bashrc" "$backup"
  echo "Created backup at $backup"
  
  # Ensure we have the git_status function for relevant prompts
  case $choice in
    1|5)
      # Add git parsing function
      cat << 'EOF' >> "$bashrc"

# Git branch parsing function
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
EOF
      ;;
    5)
      # Add git status function for developer prompt
      cat << 'EOF' >> "$bashrc"

# Git status function for detailed branch info
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
EOF
      ;;
    3)
      # Add exit status function
      cat << 'EOF' >> "$bashrc"

# Function to show command exit status
exit_status() {
  local status="$?"
  if [ $status -ne 0 ]; then
    echo -e "\[\033[31m\]✘ $status\[\033[00m\] "
  else
    echo -e "\[\033[32m\]✓\[\033[00m\] "
  fi
}
EOF
      ;;
    6)
      # Add load function
      cat << 'EOF' >> "$bashrc"

# Function to get system load with color
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
EOF
      ;;
    8)
      # Add line function
      cat << 'EOF' >> "$bashrc"

# Function to generate a horizontal line
line() {
  local columns=$(tput cols)
  local line=""
  for i in $(seq 1 $columns); do
    line+=─
  done
  echo $line
}
EOF
      ;;
  esac
  
  # Add the prompt
  cat << EOF >> "$bashrc"

# Fancy prompt setup
EOF

  # Add the appropriate PS1 variable based on choice
  case $choice in
    1)
      # Minimalist git prompt
      echo 'PS1='"'"'\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\]\$ '"'" >> "$bashrc"
      ;;
    2)
      # Professional two-line prompt
      cat << 'EOF' >> "$bashrc"
# Set up colors
reset=$(tput sgr0)
bold=$(tput bold)
green=$(tput setaf 2)
blue=$(tput setaf 4)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

# Professional two-line prompt
PS1="\[${bold}${green}\]┌─[\[${cyan}\]\t\[${reset}${bold}${green}\]]─[\[${cyan}\]\u@\h\[${reset}${bold}${green}\]]─[\[${cyan}\]\w\[${reset}${bold}${green}\]]\n\[${bold}${green}\]└──╼ \[${white}\]$ \[${reset}\]"
EOF
      ;;
    3)
      # Performance prompt with exit status
      echo 'PS1='"'"'$(exit_status)\[\033[38;5;240m\]\t\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\$ '"'" >> "$bashrc"
      ;;
    4)
      # Powerline-style prompt
      cat << 'EOF' >> "$bashrc"
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
EOF
      ;;
    5)
      # Developer prompt with git status
      echo 'PS1='"'"'\[\033[38;5;39m\]\u\[\033[00m\] at \[\033[38;5;208m\]\h\[\033[00m\] in \[\033[38;5;76m\]\w\[\033[00m\]\[\033[38;5;196m\]$(git_status)\[\033[00m\]\n\$ '"'" >> "$bashrc"
      ;;
    6)
      # Server admin prompt with load info
      echo 'PS1='"'"'\[\033[01;31m\][\t] \u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] [load: $(get_load)]\$ '"'" >> "$bashrc"
      ;;
    7)
      # Elegant and clean prompt
      echo 'PS1='"'"'\[\033[38;5;242m\]┌──[\[\033[38;5;66m\]\u\[\033[38;5;242m\]]─[\[\033[38;5;37m\]\w\[\033[38;5;242m\]]\n└─╼ \[\033[38;5;248m\]\$ \[\033[00m\]'"'" >> "$bashrc"
      ;;
    8)
      # Colorful dynamically-sized prompt
      echo 'PS1='"'"'\[\033[38;5;196m\]$(line)\n\[\033[38;5;208m\]\u\[\033[38;5;242m\]@\[\033[38;5;33m\]\h \[\033[38;5;76m\]\w\[\033[00m\]\n\$ '"'" >> "$bashrc"
      ;;
    9)
      # Compact and informative prompt
      echo 'PS1='"'"'\[\033[38;5;240m\][\t] \[\033[38;5;35m\]\u\[\033[38;5;242m\]@\[\033[38;5;27m\]\h\[\033[38;5;242m\]:\[\033[38;5;214m\]\w\[\033[00m\]\$ '"'" >> "$bashrc"
      ;;
    10)
      # Modern emoji prompt
      echo 'PS1='"'"'\[\033[01;37m\]🌈 \u\[\033[00m\] at \[\033[01;33m\]💻 \h\[\033[00m\] in \[\033[01;36m\]📁 \w\[\033[00m\]\n\[\033[01;37m\]➤ \[\033[00m\]'"'" >> "$bashrc"
      ;;
    *)
      echo "Invalid choice. No changes made."
      return 1
      ;;
  esac
  
  echo "Prompt has been added to $bashrc"
  echo "To apply, run: source $bashrc"
}

# Main menu
echo "===== Fancy Bash Prompt Installer ====="
echo "Choose a prompt style to install:"
echo "1) Minimalist Git Prompt"
echo "2) Professional Two-Line Prompt"
echo "3) Performance Prompt with Exit Status"
echo "4) Powerline-Style Prompt"
echo "5) Developer Git-Focused Prompt"
echo "6) Server Admin Prompt with Load"
echo "7) Elegant Clean Prompt"
echo "8) Colorful Dynamic-Width Prompt"
echo "9) Compact Informative Prompt"
echo "10) Modern Emoji Prompt"
echo ""
read -p "Enter your choice (1-10): " choice

install_prompt "$choice"
