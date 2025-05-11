class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      if user.email_confirmed
        session[:user_id] = user.id
        redirect_to root_path, notice: "ログインしました"
      else
        flash.now[:alert] = "メール認証が完了していません"
        render :new
      end
    else
      flash.now[:alert] = "メールまたはパスワードが正しくありません"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "ログアウトしました"
  end
end
