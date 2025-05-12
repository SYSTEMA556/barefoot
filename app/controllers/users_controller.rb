class UsersController < ApplicationController
  def new
    @user = User.new
  end
  #ユーザー一覧のために
  def index
    @users = User.all.order(:user_name)
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.email_confirmation(@user).deliver_later
      redirect_to root_path, notice: "仮登録完了。メールを確認してください。"
    else
      render :new
    end
  end

  def show
        @user = User.find(params[:id])
         @novels = @user.novels.page(params[:page]).per(12)
  end

  def confirm_email
    user = User.find_by(email_token: params[:token])
    if user
      user.confirm_email!
      redirect_to new_session_path, notice: "メール認証が完了しました。ログインしてください。"
    else
      redirect_to root_path, alert: "無効なトークンです。"
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
  end
end
