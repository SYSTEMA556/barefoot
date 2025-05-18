class Novel < ApplicationRecord
  belongs_to :user, optional: true
  enum status: { draft: 0, published: 1 }
  validates :title, presence: true
  validates :author_name, presence: true
  validates :body, presence: true
  has_many :novel_tags, dependent: :destroy
  has_many :tags, through: :novel_tags
  acts_as_taggable_on :tags 
end
