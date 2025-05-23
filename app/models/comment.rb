# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :novel

  # ゲスト用パスワード機能
  has_secure_password :guest_password, validations: false

  validates :body, presence: true, length: { maximum: 500 }

  # ログインユーザー以外はゲストパスワード必須
  with_options if: -> { user.blank? } do
    validates :guest_password, presence: true, length: { minimum: 6 }
  end
end
