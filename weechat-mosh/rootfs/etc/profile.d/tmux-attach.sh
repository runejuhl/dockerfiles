if [ -z "$TMUX" ] && [ -n "$SSH_TTY" ] && [[ $- =~ i ]]; then
    tmux attach-session -t weechat
    exit
fi
