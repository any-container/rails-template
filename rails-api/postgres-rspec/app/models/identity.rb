class Identity < ApplicationRecord
  before_validation :set_normalized_email

  validates :surname, :user_email, :normalized_email, :user_name, presence: true
  validates :user_email, :normalized_email, :user_name, uniqueness: true

  private

  def set_normalized_email
    self.normalized_email = user_email.to_s.strip.downcase.presence
  end
end
