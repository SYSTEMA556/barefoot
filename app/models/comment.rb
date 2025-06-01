class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :novel
  has_secure_password :guest_password

  # has_secure_password で authenticate が使えるようにする

  # 削除時のみゲストパスワードを必須にするバリデーション例
  validates :guest_password, presence: true, on: :destroy
end
