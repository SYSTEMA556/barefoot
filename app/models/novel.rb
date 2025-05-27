class Novel < ApplicationRecord
  belongs_to :user, optional: true
  enum status: { draft: 0, published: 1 }
  validates :title, presence: true
  validates :author_name, presence: true
  validates :body, presence: true
  has_many :novel_tags, dependent: :destroy
  has_many :tags, through: :novel_tags
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

  acts_as_taggable_on :tags 
   def self.ransackable_attributes(_auth = nil)
    %w[
      title body status user_id author_name
      created_at updated_at
    ]
  end

  def self.ransackable_associations(_auth = nil)
    %w[user]             # ← filter :user を使うので許可
  end
end
