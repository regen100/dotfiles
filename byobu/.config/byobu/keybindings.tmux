set -g prefix F12
unbind-key -n C-a

set -g prefix C-Space
set -g prefix2 C-Space
bind Space send-prefix

is_remote="ps -t '#{pane_tty}' -o comm -h --sort start_time | tail -1 | grep -e lxc -e ssh"
last_cmd="ps -t '#{pane_tty}' -o cmd -h --sort start_time | tail -1"
bind h if-shell "$is_remote" "run-shell \"tmux split-window -h '$($last_cmd)'\""
bind v if-shell "$is_remote" "run-shell \"tmux split-window -v '$($last_cmd)'\""

bind r last-pane \; send-keys Up Enter\; last-pane
