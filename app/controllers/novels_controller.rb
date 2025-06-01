# app/controllers/novels_controller.rb
class NovelsController < ApplicationController
  # 誰でもアクセス可能にしておく
  #skip_before_action :authenticate_user!, only: [:index, :show, :new, :create, :preview]
  before_action :set_novel, only: [:show, :edit, :update, :destroy]

 def index
  # 1) 検索条件を適用した Relation を最初に用意
  @q = Novel.ransack(params[:q])
  novels = @q.result(distinct: true).includes(:user, :tags)

  # 2) 並び替えを一か所に集約
  case params[:sort]
  when 'comments'
    novels = novels.left_joins(:comments)
                   .group('novels.id')
                   .order('COUNT(comments.id) DESC, novels.created_at DESC')
  when 'views'
    novels = novels.order(view_count: :desc, created_at: :desc)
  else
    novels = novels.order(created_at: :desc)
  end

  # 3) ページネーションするならこのタイミングで
   novels = novels.page(params[:page]).per(30)

  # 4) 仕上げ：ビュー用に @novels へ
  @novels = novels
end


  def new
    @novel = Novel.new
  end

  #def my_posts
  #  @novels = current_user.novels
 #                         .where(status: :published)
  #                        .order(created_at: :desc)
 #                         .page(params[:page]).per(20)
 #   render :my_posts
 # end

 # def drafts
 #   @novels = current_user.novels
   #                       .where(status: :draft)
    #                      .order(updated_at: :desc)
  #                        .page(params[:page]).per(20)
    #render :drafts
  #end

  def edit
    # @novel は set_novel で読み込まれているので何もしなくてOK
  end

 # def bookmarks
 #   @novels = current_user.bookmarked_novels
  #                        .includes(:user)
   #                       .order('bookmarks.created_at DESC')
    #                      .page(params[:page]).per(20)
   # render :bookmarks
  #end

  def destroy
    @novel.destroy
    redirect_to novels_path, notice: '作品を削除しました'
  end

  def preview
    @novel = Novel.new(novel_params)
    @novel.valid?
    render :preview
  end

  def create
    @novel = Novel.new(novel_params)

    if params[:novel][:preview_mode] == 'true'
      @novel.valid?
      render :preview and return
    end

    if @novel.save
      redirect_to novels_path, notice: '投稿しました'
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
        @novel.increment!(:view_count)

  end

 # def toggle_bookmark
  #  if current_user.bookmarked_novels.exists?(@novel.id)
   #   current_user.bookmarks.find_by(novel: @novel).destroy
    #  notice = '🔖 ブックマークを解除しました'
  #  else
   #   current_user.bookmarked_novels << @novel
    #  notice = '🔖 ブックマークしました'
   # end

   # redirect_to @novel, notice: notice
 # end

  private

  def set_novel
    @novel = Novel.find(params[:id])
  end

  def novel_params
    params.require(:novel).permit(:title, :author_name, :body, :user_name, :tag_list, :font_choice)
  end
end
