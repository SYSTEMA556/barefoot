# app/models/tag.rb
class Tag < ApplicationRecord
  # ジョインモデル NovelTag を介して Novel と多対多の関係を持つ
  has_many :novel_tags, dependent: :destroy
  has_many :novels, through: :novel_tags
end
