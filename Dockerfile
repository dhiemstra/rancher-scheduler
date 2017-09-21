ARG ruby_version=2.4

FROM ruby:$ruby_version-jessie

ENV RANCHER_CLI_VERSION=v1.0.0-alpha1

RUN \
apt-get update && \
apt-get install -y curl && \
gem install bundler

RUN \
cd /usr/local/bin && \
curl -sL https://github.com/rancher/cli/releases/download/${RANCHER_CLI_VERSION}/rancher-linux-amd64-${RANCHER_CLI_VERSION}.tar.gz | tar xvz --strip 2 && \
chmod a+x rancher

RUN \
apt-get autoremove -y curl && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/{doc,man}

COPY . ./
RUN bundle

CMD ["bundle", "exec", "clockwork", "clock.rb"]
