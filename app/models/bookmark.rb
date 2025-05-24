class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :novel

  # Ensure a user can bookmark a novel only once
  validates :user_id, uniqueness: { scope: :novel_id }
end