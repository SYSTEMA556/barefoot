# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  # ログアウト確認ページでも検索フォーム partial が使われるから…
  before_action :set_search, only: [:logout]

    def rules
    @terms_of_service_text = File.read(Rails.root.join("app/assets/texts/terms_of_service.txt"))
  end

  def logout
    # 何もしなくてOK。ビューを表示するだけよ♡
  end
  def terms_and_privacy
    # ビューを表示するだけ
  end
  private

  def set_search
    @q = Novel.ransack(params[:q])
  end
end
