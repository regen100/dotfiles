set -g prefix C-Space
set -g prefix2 F12
unbind-key -n C-a
bind Space send-prefix

is_remote="ps -t '#{pane_tty}' -o comm -h --sort start_time | tail -1 | grep -e lxc -e ssh"
last_cmd="ps -t '#{pane_tty}' -o cmd -h --sort start_time | tail -1"
bind h if-shell "$is_remote" "run-shell \"tmux split-window -h '$($last_cmd)'\""
bind v if-shell "$is_remote" "run-shell \"tmux split-window -v '$($last_cmd)'\""

bind r last-pane \; if-shell -Ft= '#{pane_in_mode}' 'send-keys -X cancel; send-keys Up Enter; last-pane' 'send-keys Up Enter; last-pane'

bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -selection clipboard"
bind-key -T root MouseDown2Pane if-shell -Ft= '#{mouse_any_flag}' \
  "send-keys -M" \
  "run 'xclip -selection clipboard -o | tmux load-buffer - && tmux paste-buffer'"
