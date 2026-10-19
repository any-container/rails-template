class Identity < ApplicationRecord
  has_secure_password

  validates :surname, :user_email, :normalized_email, :user_name, presence: true
  validates :user_email, :normalized_email, uniqueness: true
  validates :user_name, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, allow_nil: true

  def user_email=(value)
    super(value.to_s.strip)
    self.normalized_email = self.class.normalize_email(value)
  end

  def self.normalize_email(value)
    value.to_s.strip.downcase
  end
end
