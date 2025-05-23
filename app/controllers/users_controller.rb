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
      UserMailer.with(user: @user).confirmation_email.deliver_later
      flash[:notice] = "登録完了です。メールボックスをご確認くださいませ📧"
      redirect_to root_path
    else
      render :new
    end
  rescue ActiveRecord::RecordNotUnique
    @user ||= User.new(user_params)
    @user.errors.add(:email, "は既に使用されています")
    render :new
  end



  def show
        @user = User.find(params[:id])
         @novels = @user.novels.page(params[:page]).per(12)
  end

   def confirm_email
    user = User.find_by(confirmation_token: params[:token])
    if user
      user.update(confirmed_at: Time.current, confirmation_token: nil)
      flash[:notice] = "メールアドレスを確認いたしましたわ✨"
    else
      flash[:alert] = "トークンが無効です…"
    end
    redirect_to login_path
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
  end
end
