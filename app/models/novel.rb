class Novel < ApplicationRecord
  belongs_to :user, optional: true
   enum status: { draft: 0, published: 1 }
  validates :title, presence: true
  validates :author_name, presence: true
  validates :body, presence: true
end
