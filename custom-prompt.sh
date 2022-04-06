# custom-prompt.sh

### Language Versions
function rb_version {
  local version="$(rbenv version-name 2> /dev/null)"
  if [ -z "$version" ]; then version="..."; fi
  echo -e "\e[1;31mrb\e[0;31m{\e[1;30m$version\e[0;31m}\e[m"
}

function js_version {
  local version="$(nodenv version-name 2> /dev/null)"
  if [ -z "$version" ]; then version="..."; fi
  echo -e "\e[1;32mjs\e[0;32m{\e[1;30m$version\e[0;32m}\e[m"
}

function py_version {
  local version="$(pyenv version-name 2> /dev/null)"
  if [ -z "$version" ]; then version="..."; fi
  echo -e "\e[1;34mpy\e[0;34m{\e[1;30m$version\e[0;34m}\e[m"
}


### Git branch and status
function git_branch {
  local branch="$(git branch 2> /dev/null | head -1 | sed 's/\* \(.*\)/\1/')"
  if [ -n "$branch" ]; then echo -e "\033[1;32mgit:\033[1;33m$branch\033[0;30m"; fi
}

function git_status {
  if [ ! -d .git ]; then return 0; fi

  local symbol=""
  local status="$(git status --porcelain | sed 's/^\(..\)/→\1←/')"

  if [[ "$status" =~ →([MTARC]| )[MTD]← || "$status" =~ →( )[RC]← ]]; then symbol+=" 🐾"; fi
  if [[ "$status" =~ →[MTARC]([MTD]| )← || "$status" =~ →D( )← ]]; then symbol+=" ✏️ "; fi
  if [[ "$status" =~ →[?][?]← ]]; then symbol+=" 🌱"; fi
  if [[ "$status" =~ →U.← || "$status" =~ →.U← || "$status" =~ →DD← || "$status" =~ →AA← ]]; then symbol+=" 💀 💀 💀"; fi

  echo "$symbol"
}


### LifeMeter: Hearts that diminish over time
function lifemeter {
  local hour=$(TZ=America/Los_Angeles date +%H)
  if [ $hour -lt 2 ] || [ $hour -ge 24 ]; then
    local hearts="\e[5m🖤🖤🖤🖤🖤\e[m"
  elif [ $hour -lt 6 ]; then
    local hearts="🖤🖤🖤🖤🖤"
  elif [ $hour -lt 12 ]; then
    local hearts="💜🧡💛💚💙"
  elif [ $hour -lt 15 ]; then
    local hearts="💜🖤💛💚💙"
  elif [ $hour -lt 18 ]; then
    local hearts="💜🖤💛💚🖤"
  elif [ $hour -lt 21 ]; then
    local hearts="💜🖤🖤💚🖤"
  elif [ $hour -lt 24 ]; then
    local hearts="🖤🖤🖤💚🖤"
  else
    echo "Invalid Argument!" >&2
    exit 1
  fi
  echo -e $hearts
}

function exit_status {
  local status=$?
  if [ $status -eq 0 ]; then
    local output="👾"
  elif [ $status -eq 1 ]; then
    local output="🤬"
  elif [ $status -eq 127 ]; then
    local output="🤷‍♀️"
  elif [ $status -eq 130 ]; then
    local output="❌"
  else
    local output="🤬\e[0;31m{\e[1m$status\e[0;31m}\e[m"
  fi
  echo -e $output
}

PS1=''
PS1+='\n$(exit_status)'
PS1+=' \[\033[4;34m\]\u\[\033[m\]'   # username
PS1+=' \[\033[32m\]\w\[\033[m\]'     # directory

command -v rbenv  &> /dev/null && PS1+=' $(rb_version)'
command -v nodenv &> /dev/null && PS1+=' $(js_version)'
command -v pyenv  &> /dev/null && PS1+=' $(py_version)'

PS1+=' $(lifemeter)'

if [ -n '$(command -v git)' ]; then PS1+=' $(git_branch)$(git_status)'; fi

PS1+='\n \[\033[1;35m\]»\[\033[m\] ' # prompt

export PS1
