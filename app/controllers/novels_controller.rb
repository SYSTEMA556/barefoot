# app/controllers/novels_controller.rb
class NovelsController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def index

    @novels = Novel.includes(:user).order(created_at: :desc).page(params[:page]).per(20)
  end

  def show
    @novel = Novel.find(params[:id])
  end

  def new
    @novel = Novel.new
  end

  def create
    @novel = current_user.novels.build(novel_params)
    if @novel.save
      redirect_to novels_path, notice: "小説を投稿しました"
    else
      render :new
    end
  end

  private

  def novel_params
    params.require(:novel).permit(:title, :body)
  end
end
