#!/usr/bin/env bash

# From: https://github.com/junegunn/fzf/blob/master/ADVANCED.md#log-tailing

command='docker compose "$@" ps --format "table {{.Service}}\t{{.Image}}\t{{.Command}}\t{{.Service}}\t{{.Status}}\t{{.Ports}}"' \
args="$@" \
fzf \
--info=inline --layout=reverse --header-lines=1 \
--header $'⏎:bash ^O:log ^R:reload ^U:up ^D:down\n' \
--bind 'start:reload:(eval "$command")' \
--bind 'ctrl-r:reload:(eval "$command")' \
--bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
--bind 'enter:execute:docker compose $args exec {1} bash > /dev/tty' \
--bind 'ctrl-o:execute:${EDITOR:-vim} <(docker compose $args logs --no-log-prefix {1}) > /dev/tty' \
--bind 'ctrl-d:execute(docker compose $args down)+reload(eval "$command")' \
--bind 'ctrl-u:execute(docker compose $args up -d)+reload(eval "$command")' \
--preview-window up:follow \
--preview 'docker compose $args logs --no-log-prefix -f {1}'
