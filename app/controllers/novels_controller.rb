class NovelsController < ApplicationController
  before_action :set_novel, only: [:show, :edit, :update, :destroy]

  def index
    # Ransack で検索オブジェクトを生成
    @q = Novel.ransack(params[:q])

    # ベースクエリ：検索結果に関連レコードを事前ロード
    base = @q.result(distinct: true).includes(:user, :tags)

    # sort パラメータに応じてスコープを適用
    @novels = case params[:sort]
              when 'comments'
                base.order_by_comments
              when 'views'
                base.order_by_views
              when 'updated_at'
                base.order_by_updated
              else
                base.order(created_at: :desc)
              end

    # ページネーション（will_paginate を想定）
    @novels = @novels.paginate(page: params[:page], per_page: 10)
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

  private

  def set_novel
    @novel = Novel.find(params[:id])
  end

  def novel_params
    params.require(:novel).permit(:title, :body, :author_name, :font_choice, :status, :tag_list)
  end
end
