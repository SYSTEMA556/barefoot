# app/controllers/novels_controller.rb
class NovelsController < ApplicationController
  # 誰でもアクセス可能にしておく
  skip_before_action :verify_authenticity_token, only: [:preview]  # 必要なら
    before_action :require_login, only: [:bookmarks]
    before_action :set_novel, only: [:show,  :toggle_bookmark,:edit, :update, :destroy]

  #before_action :require_login, only: [:new, :create, :my_posts, :drafts]

def index
  @q = Novel.ransack(params[:q])
    @novels = @q.result(distinct: true)
               .published
               .includes(:user, :tags)
               .order(created_at: :desc)
               .page(params[:page]).per(20)
end
    #↑ここのメソッドチェーンに.publishedつけると表示されない。多分seedで作ったデータに入ってない。あと新規登録した作品が反映されていない
  def new
    @novel = Novel.new
  end
 #マイページでの自作品一覧を見るところ
  def my_posts
    @novels = current_user.novels
                          .where(status: :published)
                          .order(created_at: :desc)
                          .page(params[:page]).per(20)
    render :my_posts
  end
 #マイページでの下書き一覧を見るところ
  def drafts
    @novels = current_user.novels
                          .where(status: :draft)
                          .order(updated_at: :desc)
                          .page(params[:page]).per(20)
    render :drafts
  end
  #編集
  def edit
    # @novel は set_novel で読み込まれているので何もしなくてOK
  end

# GET /novels/bookmarks
  def bookmarks
    @novels = current_user.bookmarked_novels
                          .includes(:user)
                          .order('bookmarks.created_at DESC')
                          .page(params[:page]).per(20)
    render :bookmarks
  end

 def destroy
    @novel.destroy
    redirect_to novels_path, notice: '作品を削除しました'
  end

  # ②プレビュー画面
  def preview
    @novel = Novel.new(novel_params)
    render :preview
  end

  # ③下書き保存 または 本番投稿

  def create
    @novel = Novel.new(novel_params)
    @novel.user = current_user if logged_in?   # ログイン済みなら紐付け
      
    if params[:publish]
        @novel.status = :published
    elsif params[:draft]
      @novel.status = :draft
    end

#    @novel.status = :draft  if params[:draft] == "true"
    if @novel.save
      redirect_to novels_path, notice: @novel.draft? ? "下書き保存しました" : "投稿しました"
    else
      render :new
    end
  end

  def update
    if @novel.update(novel_params)
      redirect_to @novel, notice: '作品を更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @novel = Novel.find(params[:id])
  end
  def toggle_bookmark
    if current_user.bookmarked_novels.exists?(@novel.id)
      # すでにブックマーク済みなら解除
      current_user.bookmarks.find_by(novel: @novel).destroy
      notice = '🔖 ブックマークを解除しました'
    else
      # 未ブックマークなら追加
      current_user.bookmarked_novels << @novel
      notice = '🔖 ブックマークしました'
    end

    redirect_to @novel, notice: notice
  end

  private

    def set_novel
      @novel = Novel.find(params[:id])
    end

  def novel_params
    params.require(:novel).permit(:title,:author_name, :body,:user_name,:tag_list,:font_choice)
  end
end
