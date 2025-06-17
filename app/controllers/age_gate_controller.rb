# app/controllers/age_gate_controller.rb
class AgeGateController < ApplicationController
  layout "gate"         # ロゴだけのシンプル版レイアウト

  def new; end

  def create
    if params[:adult] == "1" && params[:agree_tos] == "1"
      cookies.signed[:adult_verified] = {
        value: true,
        expires: 1.year,
        secure: Rails.env.production?
      }
      redirect_to session.delete(:return_to) || root_path, notice: "ようこそ、夜の図書館へ"
    else
      flash.now[:alert] = "チェックが足りませんわ"
      render :new, status: :unprocessable_entity
    end
  end
end
