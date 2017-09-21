#!/bin/bash

set -eo pipefail

CMD="${1:-web}"

cd $APP_PATH

bundle exec rake db:migrate

case "$CMD" in
  clockwork)
    bundle exec clockwork clock.rb
    exit 0
    ;;
  web)
    bundle exec puma -b tcp://0.0.0.0 -e production -p 80 -w 1 -t 2:16 config.ru
    exit 0
    ;;
esac
