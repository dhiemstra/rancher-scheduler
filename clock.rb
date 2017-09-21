require 'clockwork'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end
end
