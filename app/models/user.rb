class User < ApplicationRecord
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
             BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  has_secure_password
  before_create :generate_email_token
  has_many :novels, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  validates :user_name, presence: true
  validates :password,  length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
   #パスワードは6文字以上でしましょうか
   
  attr_accessor :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest 
   
  def confirm_email!
    update(email_confirmed: true, email_token: nil)
  end

  # パスワード再設定用ダイジェストを作成
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(
      reset_digest:  User.digest(reset_token),
      reset_sent_at: Time.zone.now
    )
  end

  # 再設定用メールを送信
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # 期限切れかどうか確認（1時間以上経過でtrue）
  def password_reset_expired?
    reset_sent_at < 1.hours.ago
  end




  private

  def generate_email_token
    self.email_token = SecureRandom.urlsafe_base64
  end

   def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

    def downcase_email
      self.email = email.downcase if email.present?
    end

end