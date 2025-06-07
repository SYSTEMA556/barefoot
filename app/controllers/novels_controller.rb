class NovelsController < ApplicationController
  before_action :set_novel, only: [:show, :enter_password, :edit, :update, :destroy]
  before_action :set_search, only: [:index, :show, :new, :edit, :create, :update, :destroy, :preview]
  skip_before_action :verify_authenticity_token, only: [:preview]

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
