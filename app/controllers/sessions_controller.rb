class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.valid_password?(params[:password])
      if user.confirmed?
        session[:user_id] = user.id
        redirect_to root_path, notice: "ログインしました"
      else
        flash.now[:alert] = "メールアドレスの確認をお願いします"
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "メールまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "ログアウトしました"
  end
end
