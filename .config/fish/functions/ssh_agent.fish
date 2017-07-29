function ssh_agent --description 'launch the ssh-agent and add the id_rsa identity'
  if begin
    set -q SSH_AGENT_PID
    and kill -0 $SSH_AGENT_PID
    and grep -q '[s]sh-agent' /proc/$SSH_AGENT_PID/cmdline
  end
  echo "ssh-agent running on pid $SSH_AGENT_PID"
  else
    eval (command ssh-agent -c | sed 's/^setenv/set -Ux/')
  end
  if echo (hostname) | grep -q -E '^784f43846b95$'
    set -g identity $HOME/.ssh/id_rsa.cof
  else
    set -g identity $HOME/.ssh/id_rsa.personal
    set -x ORGNAME "levenate"
  end
  set -l fingerprint (ssh-keygen -lf $identity | awk '{print $2}')
  ssh-add -l | grep -q $fingerprint
  or ssh-add $identity
end
