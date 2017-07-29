. ~/.config/fish/aliases.fish
. ~/.config/fish/tokens.fish

set -g -x PATH /usr/local/bin ~/bin /usr/local/opt/python/libexec/bin $PATH
set -g -x ANSIBLE_CONFIG ~/.config/ansible/ansible.cfg
set fish_greeting

# fisherman
set fisher_home ~/.local/share/fisherman
set fisher_config ~/.config/fisherman
source $fisher_home/config.fish

# openssl
set -g fish_user_paths "/usr/local/opt/openssl/bin" $fish_user_paths

# ssh agent
if test -z $SSH_AGENT_PID
  eval ssh_agent
end

# python
hash fish ^&1 /dev/null;
  if test $status = 0
  eval (python -m virtualfish)
end

if test -e ~/.pythonrc
  set -x PYTHONSTARTUP ~/.pythonrc
end

# rvm
hash rvm ^ /dev/null;
  if test $status = 0
  rvm default
end

# start tmux session on login
if test -z $TMUX
  set -g -x EVENT_NOKQUEUE 1
  tmux -2 attach; or tmux -2 new-session
end
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# AWS shell completion
if test -f /usr/local/bin/aws_completer
    complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); /usr/local/bin/aws_completer | sed \'s/ $//\'; end)'
end
