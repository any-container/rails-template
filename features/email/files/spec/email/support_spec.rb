require "rails_helper"

RSpec.describe EmailHelpers do
  let(:mailer_class) do
    Class.new(ApplicationMailer) do
      def plain(to)
        mail(to: to, subject: "Plain") do |format|
          format.text { render plain: "Open https://example.test/a?x=1&y=2.\nThen https://example.test/b" }
        end
      end

      def multipart(to)
        mail(to: to, subject: "Multipart") do |format|
          format.text { render plain: "Text part https://example.test/text" }
          format.html do
            render html: '<p><a href="https://example.test/html?x=1&amp;y=2">link</a> ' \
                         "https://example.test/html?x=1&amp;y=2</p>".html_safe
          end
        end
      end

      def long_body(to)
        mail(to: to, subject: "Long", body: "https://example.test/#{'a' * 200}=\n")
      end
    end
  end

  def deliver(name)
    mailer_class.public_send(name, "user@example.org").deliver_now
  end

  it "clears deliveries before each example" do
    deliver(:plain)
    expect(ActionMailer::Base.deliveries.size).to eq(1)
  end

  it "starts each example with no deliveries" do
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  it "returns the most recent delivery from last_email" do
    deliver(:plain)
    deliver(:multipart)

    expect(last_email.subject).to eq("Multipart")
  end

  it "reads links from a plain message" do
    mail = deliver(:plain)

    expect(email_links(mail)).to eq(["https://example.test/a?x=1&y=2", "https://example.test/b"])
  end

  it "prefers the html part and decodes entities" do
    mail = deliver(:multipart)

    expect(email_links(mail)).to eq(["https://example.test/html?x=1&y=2"])
  end

  it "returns the first link" do
    expect(first_email_link(deliver(:plain))).to eq("https://example.test/a?x=1&y=2")
  end

  it "reads links from a quoted-printable body" do
    mail = Mail.new(
      to: "user@example.org",
      body: "Go to https://example.test/path?token=3Dabc=\ndef now",
      content_transfer_encoding: "quoted-printable"
    )

    expect(first_email_link(mail)).to eq("https://example.test/path?token=abcdef")
  end

  it "returns nil when there are no links" do
    mail = Mail.new(to: "user@example.org", body: "No links here")

    expect(first_email_link(mail)).to be_nil
  end
end
