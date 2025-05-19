# app/models/user.rb
class User < ApplicationRecord
  #==========  仮想属性  =======================================================
  attr_accessor :activation_token, :reset_token

  #==========  コールバック  ===================================================
  before_save   :downcase_email
  before_create :generate_email_token
  before_create :create_activation_digest

  #==========  関連  ===========================================================
  has_many :novels, dependent: :destroy

  #==========  バリデーション  =================================================
  validates :email,     presence: true, uniqueness: true
  validates :user_name, presence: true
  validates :password,  length: { minimum: 6 },
                        if: -> { new_record? || !password.nil? }

  #==========  認証  ===========================================================
  has_secure_password

  #==========  クラスメソッド  =================================================
  # URL セーフなランダムトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 文字列の BCrypt ダイジェストを返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
             BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #==========  インスタンスメソッド  ==========================================
  ## メール確認
  def confirm_email!
    update(email_confirmed: true, email_token: nil)
  end

  ## パスワード再設定
  # ダイジェスト生成
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now)
  end

  # メール送信
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # 期限切れ判定（2 時間）
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # ダイジェストとマッチするかどうかを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  #==========  private メソッド  ==============================================
  private

    # メールアドレスを小文字に
    def downcase_email
      self.email = email.downcase if email.present?
    end

    # メール確認トークン生成
    def generate_email_token
      self.email_token = SecureRandom.urlsafe_base64
    end

    # 有効化トークン＆ダイジェスト生成
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
