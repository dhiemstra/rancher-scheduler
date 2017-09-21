ARG ruby_version=2.4

FROM ruby:$ruby_version

ENV APP_PATH=/app
ENV RANCHER_CLI_VERSION=v0.6.4
ENV RAILS_ENV=production

RUN \
apt-get update && \
apt-get install -y curl apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - && \
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
apt-get update && apt-get install -y docker-ce

# Install rancher
RUN \
cd /usr/local/bin && \
curl -sL https://github.com/rancher/cli/releases/download/${RANCHER_CLI_VERSION}/rancher-linux-amd64-${RANCHER_CLI_VERSION}.tar.gz | tar xvz --strip 2 && \
chmod a+x rancher

# Cleanup
RUN \
apt-get autoremove -y apt-transport-https ca-certificates curl gnupg2 software-properties-common  && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/{doc,man}

RUN \
gem install bundler && \
mkdir $APP_PATH

WORKDIR $APP_PATH

COPY Gemfile Gemfile.lock $APP_PATH/
RUN bundle install --path /data/bundle

COPY . $APP_PATH
RUN bundle exec rake assets:precompile

ENTRYPOINT ["/app/bin/docker-entrypoint.sh"]
