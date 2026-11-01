# Base class for every mailer in the app. See features/email.md.
#
# Send with `deliver_later` or from a job, never in the request cycle. Delivery failures are
# retried by the job backend, so a mailer must be safe to run twice.
class ApplicationMailer < ActionMailer::Base
  class MissingSenderAddress < StandardError; end

  self.deliver_later_queue_name = "mailers"

  default from: -> { sender_address }
  layout "mailer"

  def self.sender_address
    ENV["EMAIL_SENDER_ADDRESS"].presence ||
      raise(MissingSenderAddress, "EMAIL_SENDER_ADDRESS is not set")
  end

  private

  def sender_address = self.class.sender_address
end
