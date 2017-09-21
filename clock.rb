require 'clockwork'
require 'clockwork/database_events'
require_relative './config/boot'
require_relative './config/environment'

module Clockwork
  configure do |config|
    config[:tz] = 'UTC'
    config[:max_threads] = 15
    config[:thread] = true
  end

  Clockwork.manager = DatabaseEvents::Manager.new

  sync_database_events model: ::Event, every: 30.seconds do |event|
    puts "Run db event"
    puts event.inspect

    # Update last run
    event.update!(last_run_at: Time.now, last_exit_status: 0, last_error: nil)
  end

  on(:after_run) do |event, t|
    puts "job_finished: #{event.inspect}"
  end

  error_handler do |error|
    # TODO
    puts "ERROR: #{error.inspect}"
  end
end
