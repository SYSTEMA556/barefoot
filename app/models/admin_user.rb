# app/models/admin_user.rb
class AdminUser < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  # ▼ これを追記（必要なら末尾に）
  def self.ransackable_attributes(_auth_object = nil)
    %w[id email created_at updated_at]
  end
  def self.ransackable_associations(_auth_object = nil)
    []                       # AdminUser は関連を検索させないなら空配列
  end
end
