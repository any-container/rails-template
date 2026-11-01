require "rails_helper"

RSpec.describe ApplicationMailer do
  include ActiveJob::TestHelper

  let(:mailer_class) do
    Class.new(ApplicationMailer) do
      def hello(to)
        mail(to: to, subject: "Hello", body: "Hi there")
      end
    end
  end

  # Jobs serialize the mailer by name, so it needs a constant.
  before { stub_const("ExampleMailer", mailer_class) }

  around do |example|
    original = ENV["EMAIL_SENDER_ADDRESS"]
    example.run
  ensure
    ENV["EMAIL_SENDER_ADDRESS"] = original
  end

  it "sends from EMAIL_SENDER_ADDRESS" do
    ENV["EMAIL_SENDER_ADDRESS"] = "sender@example.org"

    expect(mailer_class.hello("user@example.org").from).to eq(["sender@example.org"])
  end

  it "does not send without EMAIL_SENDER_ADDRESS" do
    ENV.delete("EMAIL_SENDER_ADDRESS")

    expect { mailer_class.hello("user@example.org").deliver_now }
      .to raise_error(ApplicationMailer::MissingSenderAddress)
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  it "treats a blank EMAIL_SENDER_ADDRESS as missing" do
    ENV["EMAIL_SENDER_ADDRESS"] = " "

    expect { mailer_class.hello("user@example.org").deliver_now }
      .to raise_error(ApplicationMailer::MissingSenderAddress)
  end

  it "delivers asynchronously on the mailers queue" do
    expect { mailer_class.hello("user@example.org").deliver_later }
      .to have_enqueued_mail(mailer_class, :hello).on_queue("mailers")
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  it "delivers when the enqueued job runs" do
    perform_enqueued_jobs { mailer_class.hello("user@example.org").deliver_later }

    expect(last_email.to).to eq(["user@example.org"])
    expect(last_email.from).to eq([ENV.fetch("EMAIL_SENDER_ADDRESS")])
  end
end

RSpec.describe "test environment" do
  it "uses the test delivery method" do
    expect(ActionMailer::Base.delivery_method).to eq(:test)
  end

  it "sets a default host and sender address" do
    expect(ActionMailer::Base.default_url_options[:host]).to be_present
    expect(ENV["EMAIL_SENDER_ADDRESS"]).to be_present
  end
end
