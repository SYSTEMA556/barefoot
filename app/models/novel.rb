# app/models/novel.rb
class Novel < ApplicationRecord
  belongs_to :user, optional: true

  enum status: { draft: 0, published: 1 }

  validates :title,       presence: true
  validates :author_name, presence: true
  validates :body,        presence: true

  has_many :novel_tags,           dependent: :destroy
  has_many :tags, through: :novel_tags
  has_many :comments,             dependent: :destroy
  has_many :bookmarks,            dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

  acts_as_taggable_on :tags

  scope :keyword_search, ->(kw) do
    return all if kw.blank?

    pattern = "%#{kw}%"
    left_joins(:tags)
      .where(
        "novels.title       LIKE :p OR
         novels.body        LIKE :p OR
         novels.author_name LIKE :p OR
         tags.name          LIKE :p",
        p: pattern
      ).distinct
  end

  def self.ransackable_attributes(_auth = nil)
    %w[
      title
      body
      status
      user_id
      author_name
      created_at
      updated_at
    ]
  end

  def self.ransackable_associations(_auth = nil)
    %w[user tags]
  end
end
