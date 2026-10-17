class Identity < ApplicationRecord
  validates :surname, :email, :user_name, presence: true
  validates :email, :user_name, uniqueness: true
end
