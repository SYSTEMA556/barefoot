# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  before_create :generate_email_token

  validates :email, presence: true, uniqueness: true
  validates :user_name, presence: true

  def confirm_email!
    update(email_confirmed: true, email_token: nil)
  end

  private

  def generate_email_token
    self.email_token = SecureRandom.urlsafe_base64
  end
end
