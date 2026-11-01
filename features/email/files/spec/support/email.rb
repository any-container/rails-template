# Email spec helpers. See features/email.md.
module EmailHelpers
  LINK_PATTERN = %r{https?://[^\s"'<>]+}

  # The most recent delivery.
  def last_email = ActionMailer::Base.deliveries.last

  # The links in the decoded body of a message, in order of appearance, without duplicates.
  def email_links(mail)
    part = mail.html_part || mail.text_part
    body = (part || mail).body.decoded
    CGI.unescapeHTML(body).scan(LINK_PATTERN).map { |link| link.sub(/[.,;)]+\z/, "") }.uniq
  end

  # The first link in the message.
  def first_email_link(mail) = email_links(mail).first
end

RSpec.configure do |config|
  config.include EmailHelpers

  config.before { ActionMailer::Base.deliveries.clear }
end
