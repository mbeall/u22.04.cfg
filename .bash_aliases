#!/usr/bin/env bash

# Easier navigation: .., ..., ...., .....
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# List only directories
alias lsd="ls -lF --color=auto | grep --color=never '^d'"

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Upgrades in one step
alias up='apt-get update && sudo apt-get upgrade -y'

# Always run docker in sudo
alias docker='sudo docker '

