set -eo pipefail

CMD="${1:-server}"

cd $APP_PATH

case "$CMD" in
  clockwork)
    bundle exec clockwork clock.rb
    exit 0
    ;;
  web)
    bundle exec puma -c 0.0.0.0 -e production -p 80 -w 1 -t 2:16 config.ru
    exit 0
    ;;
esac

exec "$@"
