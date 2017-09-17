require 'rubygems'
require 'clockwork'
include Clockwork

handler do |job|
  if job == 'message.registration'
    Rails.logger.info "[JOB] message.registration"
  end
end

every(3.minutes, 'message.registration')
