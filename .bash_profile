if [ "$PATHS" != "true" ]; then
  export PATHS="true"

  export WORKDIR=~/workspace
  export PATH=$PATH:/usr/local/git/bin

  # Android And Java
  # ----------------
  if hash jenv &> /dev/null; then
    export PATH=$HOME/.jenv/bin:$PATH
    eval "$(jenv init -)"
    export JAVA_HOME="$(jenv javahome)"
  fi

  # Golang
  # ------
  export PATH=$PATH:/usr/local/opt/go/libexec/bin
  export GOPATH=$WORKDIR/go
  export PATH=$PATH:$GOPATH/bin

  # Set User Paths and Defaults
  # --------------
  export PATH=/usr/local/bin:$PATH
  export PATH=/usr/local/sbin:$PATH
  export PATH=~/bin:$PATH
  export EDITOR=vim
  export VISUAL=vim
  export FPP_EDITOR=vim

  # Company specific imports
  if [[ $(hostname) =~ .+magnetic* && -s ~/bin/magnetic_aliases ]]; then
    source ~/bin/magnetic_aliases
    source ~/bin/cloud_vars
  fi

  # Capital One
  if [[ -f ~/.profile_files/.proxy.sh ]]; then
    source ~/.profile_files/.proxy.sh
  fi

  # Fuzzy search fzf
  if hash fzf &> /dev/null; then
    export FZF_DEFAULT_COMMAND='ag -l -g ""'
  fi

  # Preserve bash history
  shopt -s histappend                      # append to history, don't overwrite it
  export HISTSIZE=100000                   # big big history
  export HISTFILESIZE=100000               # big big history
  export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
  # Save and reload the history after each command finishes
  export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
fi

# python interpreter tab completion
[[ -f ~/.pythonrc ]] && export PYTHONSTARTUP=~/.pythonrc

# Command-line fuzzy finder (fzf)
# ---
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# RVM
# ---
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# SSH host completion
# -------------------
complete -A hostname rsh rcp telnet rlogin r ftp ping disk ssh

# Git
# ---
if [[ -f ~/.git-completion.sh ]]; then
  . ~/.git-completion.sh
fi
if [[ -f ~/.git-prompt.sh ]]; then
  . ~/.git-prompt.sh
fi

# Prompt
# -----
export PROMPT_COMMAND='pwd2=$(sed "s:\([^/]\)[^/]*/:\1/:g" <<<$PWD)'
export PS1="\[\033[38;5;105m\]\u\[$(tput sgr0)\]\[\033[38;5;250m\]@\[$(tput sgr0)\]\[\033[38;5;2m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\][\[$(tput sgr0)\]\[\033[38;5;45m\]$pwd2\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput sgr0)\]\[\033[38;5;11m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

# Global Aliases
# --------------
alias ll='ls -lAGhp'            # Preferred 'ls' implementation
alias cp='cp -iv'               # Preferred 'cp' implementation
alias mv='mv -iv'               # Preferred 'mv' implementation
alias ln='ln -s'                # Preferred 'ln' implementation, make symbolic link
alias cases='cd ~/cases'        # Shortcut to Cases folder
alias dropbox='cd ~/dropbox'    # Shortcut to dropbox folder
alias work='cd ~/workspace'     # Shortcut to change to work directory
alias plog='pull_logs'          # Shortcut for pulling logs
alias egrep='egrep --color'     # Add color to egrep results
alias grep='grep --color'       # Add color to egrep results
alias xit='exit'                # Usual typo for exit
alias cim='vim'                 # Usual typo for vim
alias vi='vim'                  # Preferred editor

# directory navigation
cd() { builtin cd "$@"; ll; }       # Always list directory contents upon 'cd'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'

# chef
smc() { cd "$MASTERCHEF"; } # Shortcut to change to masterchef directory
cb() { cd "$MASTERCHEF"/cookbooks/"$*"; }
# auto-complete on cb
_cb() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$(ls $MASTERCHEF/cookbooks/)" -- $cur) )
}
complete -F _cb cb

# ansible
pla() { cd "${ANSIBLE_DIR}"; } # shortcut to change to the ansible directory
rle() { vim "${ANSIBLE_DIR}/roles/$*/tasks/main.yml"; }
# auto-complete on role
_rle() {
  local cur=${COMP_WORDS[COMP_WORDS]}
  COMPREPLY=( $(compgen -W "$(ls "${ANSIBLE_DIR}/roles/")" -- $cur) )
}
complete -F _rle rle

# Kitchen aliases
kc() { kitchen destroy "${1}"; bundle exec kitchen converge; }  # shortcut to destroy and then converge kitchen
alias kv='bundle exec kitchen verify'                           # shortcut to verify and then converge kitchen
alias kc='bundle exec kitchen converge'                         # shortcut to converge kitchen
alias kt='bundle exec kitchen test'                             # shortcut to test kitchen
alias kd='kitchen destroy'                                      # shortcut to test kitchen
alias be='bundle exec'                                          # shortcut for bundle exec with socks proxy

# git aliases
alias gps='git pull --rebase; git submodule update --init'
alias gcp='git checkout master && git pull'

# mount android file image
function mountAndroid { hdiutil attach ~/android.dmg -mountpoint /Volumes/android; }

# Always cd into newly created directory
# --------------------------------------
mkc() { mkdir -pv "$@" && cd $_; }

# TMUX, start session at login
# ----------------------------
#if which tmux >/dev/null 2>&1; then
#    #if not inside a tmux session, and if no session is started, start a new session
#    test -z "$TMUX" && (tmux attach || tmux new-session)
#fi

# TMUX, get session name
# ----------------------
if [[ ! -z "$TMUX" ]] ; then
  tix=`tmux display-message -p "#S"`
fi

# open jira url
# --------------
jira() {
  open https://amplify-jira.atlassian.net/browse/$1
}

# --------------------------------------------------
# ectract: pass any archive and it will be extracted
#          Ecample: extract test.tar.gz
# --------------------------------------------------
extract() {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# ---------------------------------------------------------------------------------------------
# mans: Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#       displays paginated result with colored search terms and two lines surrounding each hit.
#       Example: mans mplayer codec
# ---------------------------------------------------------------------------------------------
mans() {
        man $1 | grep -iC2 --color=always $2 | less
    }

# --------------------------------------------------------------------------------------
# Chef conveniences
#
# For "*cb" commands, these functions rely on the context of the cookbook directory
# you're currently in to determine what cookbook to operate on: bumpcb, putcb, promotecb
# should all be run from within the cookbook directory you wish to bump, upload,
# or promote to an environment.
#
# putrole and putenv rely on your knife.cb configuration to locate the "roles"
# and "environments" dirs beneath your Chef repository root.
# --------------------------------------------------------------------------------------
alias kssh='knife ssh -a fqdn -C 10'

# Amazon EC2 Conveniences
# -----------------------
complete -C aws_completer aws

sshid() {
  ip=$(aws ec2 describe-instances --instance-id "$1" | python -c \
    'import sys, json; print json.load(sys.stdin)["Reservations"][0]\
    ["Instances"][0]["PrivateIpAddress"]')
  shift
  ssh "$ip" "$@"
}

getip() {
  aws ec2 describe-instances --instance-id "$1" | egrep -i ipaddres | head -n 1 | awk '{ print $2 }' | tr -d '"'
}

# Packet Capturing
# ----------------
airportoff() {
        wifi=`networksetup -listallhardwareports | grep -A1 Wi-Fi | awk '{print $2}' | tail -n1`
        networksetup -setairportpower $wifi off
}
airporton() {
        wifi=`networksetup -listallhardwareports | grep -A1 Wi-Fi | awk '{print $2}' | tail -n1`
        networksetup -setairportpower $wifi off
}
airportcycle() {
        airportoff
        airporton
}

# SSH, add private key permanently to authentication agent
# -------------------------------------------------------
ssh-add ~/.ssh/id_rsa.personal &>/dev/null
