# app/models/novel.rb
class Novel < ApplicationRecord
  belongs_to :user, optional: true

  has_secure_password validations: false

  # 基本バリデーション
  validates :password,       presence: true, on: :create
  validates :title,          presence: true
  validates :author_name,    presence: true
  validates :body,           presence: true
  validates :caution_reason, presence: true, if: :caution?
  validates :caution_reason, length: { maximum: 180 }, allow_blank: true

  # フォント選択肢の検証
  validates :font_choice, inclusion: {
    in: ["こぶり明朝", "游ゴシック", "MS明朝", "ヒラギノ角ゴ", "Shippori Mincho", "Noto Serif JP"],
    allow_nil: true
  }

  # アソシエーション
  has_many :novel_tags,        dependent: :destroy
  has_many :tags, through: :novel_tags
  has_many :comments,          dependent: :destroy
  has_many :bookmarks,         dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

  # タグ機能
  acts_as_taggable_on :tags

  # 検索スコープ
  scope :recent,        -> { order(created_at: :desc) }
  scope :no_tags,       -> { left_joins(:tags).where(tags: { id: nil }) }

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

  # ソート用スコープ
  scope :with_comments_count, -> {
    left_joins(:comments)
      .select('novels.*, COUNT(comments.id) AS comments_count')
      .group('novels.id')
  }
  scope :order_by_comments, -> {
    with_comments_count.order(Arel.sql('comments_count DESC, novels.created_at DESC'))
  }
  scope :order_by_views,    -> { order(view_count: :desc, created_at: :desc) }
  scope :order_by_updated,  -> { order(updated_at: :desc) }

  # Ransack 用ホワイトリスト
  def self.ransackable_scopes(_auth = false)
    %i[recent no_tags]
  end

  def self.ransackable_attributes(_auth = false)
    %w[
      title
      body
      user_id
      author_name
      created_at
      updated_at
    ]
  end

  def self.ransackable_associations(_auth = false)
    %w[user tags]
  end

  # 編集時にパスワード要否を判定
  def password_required_for_edit?
    password_digest.present?
  end
end
