class Identity < ApplicationRecord
  validates :surname, :user_email, :normalized_email, :user_name, presence: true
  validates :user_email, :normalized_email, :user_name, uniqueness: true
end
