class Novel < ApplicationRecord
  belongs_to :user, optional: true

  enum status: { draft: 0, published: 1 }
  has_secure_password validations: false  

  scope :recent, -> { order(created_at: :desc) }
  scope :no_tags, -> { left_joins(:tags).where(tags: { id: nil }) }
  scope :published, -> { where(status: 'published') }

  validates :password, presence: true, on: :create
  validates :title,       presence: true
  validates :author_name, presence: true
  validates :body,        presence: true
  validates :font_choice, inclusion: {
    in: ["こぶり明朝", "游ゴシック", "MS明朝", "ヒラギノ角ゴ", "Shippori Mincho", "Noto Serif JP"],
    allow_nil: true
  }

  has_many :novel_tags,    dependent: :destroy
  has_many :tags, through: :novel_tags
  has_many :comments,      dependent: :destroy
  has_many :bookmarks,     dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmarks, source: :user

  acts_as_taggable_on :tags

  # キーワード検索用スコープ（既存）
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

  # ここから追加するソート用スコープたち ↓

  # コメント数（降順）でソートし、同数の場合は作成日時 DESC
  scope :with_comments_count, -> {
    left_joins(:comments)
      .select('novels.*, COUNT(comments.id) AS comments_count')
      .group('novels.id')
  }

  scope :order_by_comments, -> {
    with_comments_count
      .order(Arel.sql('comments_count DESC, novels.created_at DESC'))
  }

  # view_count カラムを使って降順ソートし、同数の場合は作成日時 DESC
  scope :order_by_views, -> {
    order(view_count: :desc, created_at: :desc)
  }

    # 本⽂の単語数を計算する ransacker
  ransacker :word_count do
    # 空白で区切られた単語数
    Arel.sql("LENGTH(body) - LENGTH(REPLACE(body, ' ', '')) + 1")
  end
  # updated_at を使って更新日時 DESC ソート
  scope :order_by_updated, -> {
    order(updated_at: :desc)
  }
  
  def self.ransackable_scopes(authenticated = false)
    %i[recent no_tags published]
  end

  # ransack 用ホワイトリスト（既存）
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

  def password_required_for_edit?
    password_digest.present?
  end

  def self.ransackable_associations(_auth = nil)
    %w[user tags]
  end
end