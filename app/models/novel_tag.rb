class NovelTag < ApplicationRecord
  belongs_to :novel
  belongs_to :tag
end
