export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

alias l.="ls -GFhd .*"
alias ls="ls -GFh"
alias be="bundle exec"
alias tree="tree -CAF"

if [ -n "$(command -v rbenv)" ]; then eval "$(rbenv init -)"; fi
if [ -n "$(command -v nodenv)" ]; then eval "$(nodenv init -)"; fi
if [ -n "$(command -v pyenv)" ]; then eval "$(pyenv init -)"; fi

export EDITOR=code

source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
source "$(dirname ${BASH_SOURCE[0]})/custom-prompt.sh"
