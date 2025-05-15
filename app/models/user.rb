# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_secure_password
  before_create :generate_email_token
  #after_create  :send_confirmation_email 
  #(コントローラー側で送る処理してるので消す)

  has_many :novels, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :user_name, presence: true

  def confirm_email!
    update(email_confirmed: true, email_token: nil)
  end

  private

  def generate_email_token
    self.email_token = SecureRandom.urlsafe_base64
  end

   # def send_confirmation_email
   #  UserMailer.email_confirmation(self).deliver_later
 #  end

   def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
