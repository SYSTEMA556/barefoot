class NovelsController < ApplicationController
  before_action :set_novel, only: [:show, :enter_password, :verify_password,:edit, :update, :destroy]
  before_action :set_search, only: [:index, :show, :new, :edit, :create, :update, :destroy, :preview]
  before_action :require_age_verification

  skip_before_action :verify_authenticity_token, only: [:preview]

  def index
  @q = Novel.ransack(params[:q])
  page     = (params[:page] || 1).to_i
  per_page = 50
  

    #★ キャッシュキーをここで定義しないと NameError になるの  
    q_hash = params[:q]&.to_unsafe_h || {}
  query_segment = q_hash.sort.map { |k, v| "#{k}=#{v}" }.join("&")
  cache_key = [
    "novels/index",
    query_segment.present? ? query_segment : "no_query",
    params[:sort] || 'default',
    "page:#{page}"
  ].join("/")

  cache_data = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
    Rails.logger.info "★ Cache MISS: #{cache_key}"

      # ① 検索結果の Relation を取得  
    base = @q.result(distinct: true).includes(:user, :tags)

    sorted = case params[:sort]
             when 'comments'
               base.left_joins(:comments)
                   .group('novels.id')
                   .order('COUNT(comments.id) DESC, novels.created_at DESC')
             when 'views'
               base.order(view_count: :desc, created_at: :desc)
             when 'updated_at'
               base.order(updated_at: :desc)
             else
               base.order(created_at: :desc)
             end

    paginated = sorted.page(page).per(per_page)
    counts = Comment.where(novel_id: paginated.map(&:id))
                    .group(:novel_id)
                    .count

    {
      novels: paginated.to_a,
      total_count: paginated.total_count,
      comment_counts: counts
    }
  end

  Rails.logger.info "★ Cache HIT: #{cache_key}" if Rails.cache.exist?(cache_key)


    #★ Kaminari の配列ページネーションに復元  
  @novels = Kaminari.paginate_array(
    cache_data[:novels],
    total_count: cache_data[:total_count]
  ).page(page).per(per_page)

  @comment_counts = cache_data[:comment_counts]
end

  def preview
    @novel          = Novel.new(novel_params)
    @preview_params = novel_params
    render :preview
  end


def show
  # ✅ 二重取得を削除
  if @novel.caution? && !cookies["novel_read_#{@novel.id}"]
    render :caution and return
  end
end

def confirm_caution
  @novel = Novel.find(params[:id])
  cookies["novel_read_#{@novel.id}"] = true
  redirect_to novel_path(@novel)
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
    :password,
    :password_confirmation,
    :font_choice,
    :caution,
    :caution_reason,
    :tag_list # acts-as-taggable-on を使っているならこれも
  )
end
end
