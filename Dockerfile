ARG ruby_version=2.4

FROM ruby:$ruby_version-jessie

ENV APP_PATH=/app
ENV RANCHER_CLI_VERSION=v0.6.4

RUN \
apt-get update && \
apt-get install -y curl && \
gem install bundler

RUN \
cd /usr/local/bin && \
curl -sL https://github.com/rancher/cli/releases/download/${RANCHER_CLI_VERSION}/rancher-linux-amd64-${RANCHER_CLI_VERSION}.tar.gz | tar xvz --strip 2 && \
chmod a+x rancher && \
apt-get autoremove -y curl && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/{doc,man} && \
mkdir $APP_PATH

WORKDIR $APP_PATH

COPY . $APP_PATH

RUN bundle install --path /data/bundle

ENTRYPOINT ["/app/bin/docker-entrypoint.sh"]
