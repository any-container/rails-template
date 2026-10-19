require "rails_helper"

RSpec.describe Identity do
  def build(overrides = {})
    described_class.new({ surname: "Doe", user_email: "Jane@Example.com ", user_name: "jane", password: "s3cret-pass" }.merge(overrides))
  end

  it "is valid with required attributes and normalizes the email" do
    identity = build
    expect(identity).to be_valid
    expect(identity.user_email).to eq("Jane@Example.com")
    expect(identity.normalized_email).to eq("jane@example.com")
  end

  it "stores an encrypted password and authenticates" do
    identity = build.tap(&:save!)
    expect(identity.password_digest).not_to include("s3cret-pass")
    expect(identity.authenticate("s3cret-pass")).to eq(identity)
    expect(identity.authenticate("wrong")).to be(false)
  end

  it "requires a surname and a password of at least 8 characters" do
    expect(build(surname: nil)).not_to be_valid
    expect(build(password: "short")).not_to be_valid
    expect(build(password: nil)).not_to be_valid
  end

  it "enforces uniqueness of email (case-insensitively) and user name" do
    build.save!
    expect(build(user_email: "JANE@example.com", user_name: "other")).not_to be_valid
    expect(build(user_email: "other@example.com", user_name: "JANE")).not_to be_valid
  end
end
