# A pending sign-up. Confirming its emailed token creates the Identity.
class IdentityRegistration < ApplicationRecord
  has_secure_password

  attr_reader :confirmation_token

  validates :surname, :user_email, :normalized_email, :user_name, :confirmation_digest, :expires_at, presence: true
  validates :password, length: { minimum: 8 }, allow_nil: true
  validate :user_email_and_user_name_available, on: :create

  scope :pending, -> { where(confirmed_at: nil).where("expires_at > ?", Time.current) }

  def self.digest(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  # Builds a pending registration with a fresh confirmation token.
  def self.start(attributes)
    registration = new(attributes)
    registration.regenerate_confirmation_token
    registration
  end

  def user_email=(value)
    super(value.to_s.strip)
    self.normalized_email = Identity.normalize_email(value)
  end

  def regenerate_confirmation_token
    @confirmation_token = SecureRandom.urlsafe_base64(32)
    self.confirmation_digest = self.class.digest(@confirmation_token)
    self.expires_at = Rails.configuration.x.identities.confirmation_ttl.from_now
  end

  # Returns the new Identity (persisted, or carrying errors if the email or
  # user name was taken in the meantime), or nil for an unknown, used or
  # expired token.
  def self.confirm(token)
    return if token.blank?

    transaction do
      registration = pending.lock.find_by(confirmation_digest: digest(token))
      return unless registration

      identity = registration.build_identity
      if identity.save
        registration.update_columns(confirmed_at: Time.current)
      end
      identity
    end
  end

  def build_identity
    Identity.new(
      given_name: given_name,
      surname: surname,
      user_email: user_email,
      user_name: user_name,
      password_digest: password_digest
    )
  end

  private

  def user_email_and_user_name_available
    errors.add(:user_email, :taken) if Identity.exists?(normalized_email: normalized_email)
    errors.add(:user_name, :taken) if Identity.exists?([ "lower(user_name) = ?", user_name.to_s.downcase ])
  end
end
