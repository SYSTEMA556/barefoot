class AgeGateController < ApplicationController
  layout "gate"  # ロゴだけのシンプルなレイアウト

  def new
    # 直前に見ようとしていたページがあれば記憶しておく
   # session[:return_to] ||= request.referer unless on_gate_page?
  end

  def create
    if params[:adult] == "1" && params[:agree_tos] == "1"
      cookies.signed[:adult_verified] = {
        value: true,
        expires: 1.year,
        secure: Rails.env.production?
      }
      redirect_to(session.delete(:return_to) || novels_path, notice: "ようこそ、夜の図書館へ")
    else
      flash.now[:alert] = "チェックが足りませんわ。もう一度ご確認を。"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def on_gate_page?
    request.path == gate_path
  end
end
