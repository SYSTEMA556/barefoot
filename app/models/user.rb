# app/models/user.rb
class User < ApplicationRecord


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
