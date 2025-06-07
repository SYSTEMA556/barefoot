# app/models/bookmark.rb
class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :novel

  # 同じユーザーが同じノベルをお気に入りにできないようにバリデーション
  validates :user_id, uniqueness: { scope: :novel_id }
end

# app/models/user.rb
class User < ApplicationRecord
  # 既に Devise と OmniAuth 用の設定が書かれている想定
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_novels, through: :bookmarks, source: :novel
end

# app/models/novel.rb
class Novel < ApplicationRecord
  # 既存のバリデーションなどはそのまま
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarking_users, through: :bookmarks, source: :user
end
