require 'timeout'
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
    logger = Clockwork.manager.logger
    logger.info "Running event ##{event.id}.."

    begin
      output = Timeout::timeout(120) {
        output = %x(bin/rancher exec -i #{event.image} #{event.command})
        logger.info output
        output
      }
      exit_code = $?.exitstatus
      if exit_code != 0
        error_message = output
        logger.error error_message
      end
    rescue Timeout::TimeoutError
      logger.error "Job timed out.."
      error_message = 'Timeout error'
      exit_code = -2
    rescue
      logger.error "Job run error.."
      error_message = $!.message
      exit_code = -1
    end

    # Update last run
    event.update!(last_run_at: Time.now, last_exit_code: exit_code, last_error_message: output || error_message)
  end

  error_handler do |error|
    logger.error(error)
  end
end
