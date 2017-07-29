function ssh --description 'set tmux pane title on ssh'
  if test $TMUX
    set host $argv[-1]
    tmux rename-window (echo $host | cut -d . -f 1,2)
    tmux set -q allow-rename off
    command ssh $argv
    tmux set-window-option automatic-rename "on" 1>/dev/null
  else
    command ssh $argv
  end
end

