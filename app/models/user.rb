# app/models/user.rb
class User < ApplicationRecord
  # ───────────────── Devise ───────────────────
  # :confirmable を入れると Devise 流のメール確認が有効になる
   devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:twitter2]

  def self.from_omniauth(auth)
    # 既存ユーザーをUIDで検索し、なければ作成
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid      = auth.uid
      # Twitter はメールアドレスを返さない場合があるので注意
      user.email    = auth.info.email || "#{auth.uid}@twitter.example.com"
      user.password = Devise.friendly_token[0, 20]
      user.name     = auth.info.name
      # その他の必要情報があればここで紐付ける
    end
end
  # ──────────────── 関連 ──────────────────────
  has_many :novels,   dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  has_many :bookmarked_novels, through: :bookmarks, source: :novel

  # ──────────── バリデーション ────────────────
  validates :user_name, presence: true, length: { maximum: 50 }

  # ────────────── コールバック ────────────────
  before_validation :downcase_email

  # ───────────── Ransack allowlist ─────────────
  def self.ransackable_attributes(_auth_object = nil)
    %w[id email user_name confirmed_at created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  # ───────────── private ──────────────────────
  private

  def downcase_email
    self.email = email.to_s.downcase
  end
end
