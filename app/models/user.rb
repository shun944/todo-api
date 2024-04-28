class User < ApplicationRecord
  has_many :todos, dependent: :destroy
  validates :username, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
