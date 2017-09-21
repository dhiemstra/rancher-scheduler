require 'sinatra/base'

Bundler.require(*Rails.groups)

module Scheduler < Sinatra::Base
  set :sessions, true

  get '/' do
    'Hello world!'
  end
end
