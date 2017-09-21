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
      output = Timeout::timeout(5) {
        %x(rancher docker run -it --rm #{event.image} #{event.command} 2>&1)
      }
      exit_code = $?.exitstatus
      error_message = output if exit_code != 0
    rescue Timeout::TimeoutError
      error_message = 'Timeout error'
      exit_code = -2
    rescue
      error_message = $!.message
      exit_code = -1
    end

    logger.debug "Job completed with exit code #{exit_code}"

    # Update last run
    event.update!(last_run_at: Time.now, last_exit_code: exit_code, last_error_message: error_message)
  end

  error_handler do |error|
    logger.error(error)
  end
end
