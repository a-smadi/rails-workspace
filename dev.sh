#!/bin/bash

set -e # Exit on errors

if [ -n "$TMUX" ]; then
  export NESTED_TMUX=1
  export TMUX=''
fi

if [ ! $RAILS_APP_DIR ]; then export RAILS_APP_DIR=$HOME/workspace/cyber-claims-server; fi

cd $RAILS_APP_DIR

tmux new-session  -d -s rails-app
tmux set-environment -t rails-app -g RAILS_APP_DIR $RAILS_APP_DIR

tmux new-window     -t rails-app -n 'server'
tmux send-key       -t rails-app 'cd $RAILS_APP_DIR'      Enter 'rails s'                                         Enter
tmux split-window   -t rails-app
tmux send-key       -t rails-app 'cd $RAILS_APP_DIR'      Enter 'yarn --cwd $(pwd)/frontend dev'                  Enter
tmux split-window   -t rails-app
tmux send-key       -t rails-app 'cd $RAILS_APP_DIR'      Enter 'yarn --cwd $(pwd)/frontend gulp legacy-watch'    Enter

tmux new-window     -t rails-app -n 'console'
tmux send-key       -t rails-app 'cd $RAILS_APP_DIR'      Enter 'rails c'                                         Enter

tmux new-window     -t rails-app -n 'redis'
tmux send-key       -t rails-app 'cd $RAILS_APP_DIR'      Enter 'redis-server'                                    Enter
tmux split-window   -t rails-app
tmux send-key       -t rails-app 'cd $RAILS_APP_DIR'      Enter 'redis-cli'                                       Enter

tmux new-window     -t rails-app -n 'vim'
tmux send-key       -t rails-app 'cd $RAILS_APP_DIR'      Enter 'vim .'                                           Enter

tmux new-window     -t rails-app -n 'Elasticsearch'
tmux send-key       -t rails-app 'cd $RAILS_APP_DIR'      Enter '~/elasticsearch-7.1.0/bin/elasticsearch'         Enter

tmux new-window     -t rails-app -n 'mysql'
tmux send-key       -t rails-app 'cd $RAILS_APP_DIR'      Enter 'mysql -uroot -p'                                 Enter

if [ -z "$NESTED_TMUX" ]; then
  tmux -2 attach-session -t rails-app
else
  tmux -2 switch-client -t rails-app
fi
