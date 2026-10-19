require "rails_helper"

RSpec.describe IdentityRegistration do
  include ActiveSupport::Testing::TimeHelpers

  let(:attributes) { { surname: "Doe", user_email: "Jane@Example.com", user_name: "jane", password: "s3cret-pass" } }

  describe ".start" do
    it "creates a pending registration with a hashed token and password" do
      registration = described_class.start(attributes)
      expect(registration.save).to be(true)
      expect(registration.confirmation_token).to be_present
      expect(registration.confirmation_digest).to eq(described_class.digest(registration.confirmation_token))
      expect(registration.confirmation_digest).not_to eq(registration.confirmation_token)
      expect(registration.password_digest).not_to include("s3cret-pass")
    end

    it "rejects an email or user name already held by an identity" do
      Identity.create!(attributes)
      registration = described_class.start(attributes.merge(user_email: "jane@example.com", user_name: "JANE"))
      expect(registration).not_to be_valid
      expect(registration.errors.attribute_names).to include(:user_email, :user_name)
    end
  end

  describe ".confirm" do
    let!(:registration) { described_class.start(attributes).tap(&:save!) }
    let(:token) { registration.confirmation_token }

    it "creates an Identity carrying the registered password" do
      identity = described_class.confirm(token)
      expect(identity).to be_persisted
      expect(identity.authenticate("s3cret-pass")).to eq(identity)
      expect(registration.reload.confirmed_at).to be_present
    end

    it "cannot be used twice" do
      described_class.confirm(token)
      expect(described_class.confirm(token)).to be_nil
      expect(Identity.count).to eq(1)
    end

    it "returns nil for blank, unknown or expired tokens" do
      expect(described_class.confirm(nil)).to be_nil
      expect(described_class.confirm("nope")).to be_nil
      travel_to(25.hours.from_now) { expect(described_class.confirm(token)).to be_nil }
    end

    it "returns an unsaved identity with errors if the email was taken meanwhile" do
      Identity.create!(attributes.merge(password: "another-pass"))
      identity = described_class.confirm(token)
      expect(identity).not_to be_persisted
      expect(identity.errors).to be_present
      expect(registration.reload.confirmed_at).to be_nil
    end
  end
end
