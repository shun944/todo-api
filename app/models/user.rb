class User < ApplicationRecord
  has_secure_password
  has_many :todos, dependent: :destroy
  validates :username, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
end
