#!/bin/bash

set -e # Exit on errors

if [ -n "$TMUX" ]; then
  export NESTED_TMUX=1
  export TMUX=''
fi

if [ ! $SHERPA_APP_DIR ]; then export SHERPA_APP_DIR=$HOME/workspace/sherpa-backend; fi

cd $SHERPA_APP_DIR

tmux new-session  -d -s sherpa-backend
tmux set-environment -t sherpa-backend -g SHERPA_APP_DIR $SHERPA_APP_DIR

tmux new-window     -t sherpa-backend -n 'server'
tmux send-key       -t sherpa-backend 'cd $SHERPA_APP_DIR'      Enter 'rails s'                                         Enter

tmux new-window     -t sherpa-backend -n 'console'
tmux send-key       -t sherpa-backend 'cd $SHERPA_APP_DIR'      Enter 'rails c'                                         Enter

tmux new-window     -t sherpa-backend -n 'redis'
tmux send-key       -t sherpa-backend 'cd $SHERPA_APP_DIR'      Enter 'redis-server'                                    Enter
tmux split-window   -t sherpa-backend
tmux send-key       -t sherpa-backend 'cd $SHERPA_APP_DIR'      Enter 'redis-cli'                                       Enter

tmux new-window     -t sherpa-backend -n 'vim'
tmux send-key       -t sherpa-backend 'cd $SHERPA_APP_DIR'      Enter 'vim .'                                           Enter

tmux new-window     -t sherpa-backend -n 'guard'
tmux send-key       -t sherpa-backend 'cd $SHERPA_APP_DIR'      Enter 'bundle exec guard'                               Enter

tmux new-window     -t sherpa-backend -n 'psql'
tmux send-key       -t sherpa-backend 'cd $SHERPA_APP_DIR'      Enter 'psql -U root'                                    Enter

if [ -z "$NESTED_TMUX" ]; then
  tmux -2 attach-session -t sherpa-backend
else
  tmux -2 switch-client -t sherpa-backend
fi
