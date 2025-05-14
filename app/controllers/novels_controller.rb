# app/controllers/novels_controller.rb
class NovelsController < ApplicationController
  # 誰でもアクセス可能にしておく
  skip_before_action :verify_authenticity_token, only: [:preview]  # 必要なら
  #before_action :require_login, only: [:new, :create, :my_posts, :drafts]

  def index
  @novels = Novel.includes(:user)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(20).published
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


  def show
    @novel = Novel.find(params[:id])
  end

  private

  def novel_params
    params.require(:novel).permit(:title,:author_name, :body,:user_name)
  end
end
