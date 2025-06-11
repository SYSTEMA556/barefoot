# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  # ログアウト確認ページでも検索フォーム partial が使われるから…
  before_action :set_search, only: [:logout]

  def logout
    # 何もしなくてOK。ビューを表示するだけよ♡
  end

  private

  def set_search
    @q = Novel.ransack(params[:q])
  end
end
