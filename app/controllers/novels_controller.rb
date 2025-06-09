class NovelsController < ApplicationController
  before_action :set_novel, only: [:show, :enter_password, :edit, :update, :destroy]
  before_action :set_search, only: [:index, :show, :new, :edit, :create, :update, :destroy, :preview]
  skip_before_action :verify_authenticity_token, only: [:preview]

  def index
    @q = Novel.ransack(params[:q])

    # キャッシュキーの定義（お忘れなく♡）
    q_hash        = params[:q]&.to_unsafe_h || {}
    query_segment = q_hash.sort.map { |k, v| "#{k}=#{v}" }.join("&")
    cache_key     = [
      "novels/index",
      query_segment.present? ? query_segment : "no_query",
      params[:sort] || 'default',
      "page:#{params[:page] || 1}"
    ].join("/")

    page     = (params[:page] || 1).to_i
    per_page = 10

    # ── キャッシュにハッシュを返す ───────────────────────────
  cache_data = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do


  Rails.logger.info "★ Cache MISS: #{cache_key}"

  # ① 検索結果のRelationを取得
  base   = @q.result(distinct: true).includes(:user, :tags)

  # ② ソートを適用
  sorted = case params[:sort]
           when 'comments'   then base.order_by_comments
           when 'views'      then base.order_by_views
           when 'updated_at' then base.order_by_updated
           else                  base.order(created_at: :desc)
           end

  # ③ ページネーションして配列化
  paginated = sorted.paginate(page: page, per_page: per_page)

  # ④ コメント数をまとめて取得
  counts = Comment.where(novel_id: paginated.map(&:id))
                  .group(:novel_id)
                  .count

  {
    novels:         paginated.to_a,
    total_entries:  paginated.total_entries,
    comment_counts: counts
  }
end
  @comment_counts = cache_data[:comment_counts]
# 再構築後…
@novels = WillPaginate::Collection.create(page, per_page, cache_data[:total_entries]) do |pager|
  pager.replace(cache_data[:novels])
end
if Rails.cache.exist?(cache_key)
  Rails.logger.info "★ Cache HIT: #{cache_key}"
end
    # ── ハッシュから取り出して WillPaginate::Collection を再構築 ──
    novels_array   = cache_data[:novels]
    total_entries  = cache_data[:total_entries]

    @novels = WillPaginate::Collection.create(page, per_page, total_entries) do |pager|
      pager.replace(novels_array)
    end
  end


  def preview
    @novel          = Novel.new(novel_params)
    @preview_params = novel_params
    render :preview
  end

  def show
    # @novel は set_novel で既に取得済み
  end

  def new
    @novel = Novel.new
  end

  def create
    @novel = Novel.new(novel_params)
    if @novel.save
      redirect_to @novel, notice: "新しい作品を投稿しましたわ♡"
    else
      render :new
    end
  end

  def edit
    # @novel は set_novel で既に取得済み
  end

  def update
    if @novel.update(novel_params)
      redirect_to @novel, notice: "作品を更新しましたわ！"
    else
      render :edit
    end
  end

  def destroy
    @novel.destroy
    redirect_to novels_path, notice: "作品を削除しましたわ♡"
  end
  def set_search
    @q = Novel.ransack(params[:q])
  end
  def enter_password
    @novel = Novel.find(params[:id])
    @q     = Novel.ransack(params[:q])  # ← これを追加！
    # あとは既存の処理…
  end

  def verify_password
    # モデルの authenticate メソッドで検証。trueならばedit画面へリダイレクト
    if @novel.authenticate(params[:password])
      redirect_to edit_novel_path(@novel)
    else
      flash.now[:alert] = "パスワードが違いますわよ…"
      render :enter_password
    end
  end


  private

  def set_novel
    @novel = Novel.find(params[:id])
  end

  def novel_params
    params.require(:novel).permit(
      :title,
      :author_name,
      :body,
      :font_choice,
      :status,
      :password,
      :password_confirmation,
      tag_ids: []  # もしタグを配列で受け取るなら
    )
  end
end
