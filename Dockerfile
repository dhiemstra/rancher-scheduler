FROM ruby:2.4-jessie

RUN \
apt-get update && \
gem install bundler

COPY . ./
RUN bundle

CMD ["bundle", "exec", "clockwork", "clock.rb"]
