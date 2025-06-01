# app/controllers/password_resets_controller.rb
class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      # ← ここを
      @user.send_reset_password_instructions
      # ← こう書き換えるのですわ
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new', status: :unprocessable_entity
    end
  end
  def edit
    # @userはbefore_actionでセット済み
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit', status: :unprocessable_entity
    elsif @user.update(user_params)
      @user.update_column(:reset_digest, nil)  # セキュリティ向上
      reset_session
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end
def valid_user
  Rails.logger.debug "STEP1 user: #{@user&.id}"
  Rails.logger.debug "STEP2 email_confirmed?: #{@user&.email_confirmed?}"
  Rails.logger.debug "STEP3 authenticated?: #{@user&.authenticated?(:reset, params[:id])}"
  unless @user && @user.email_confirmed? && @user.authenticated?(:reset, params[:id])
    Rails.logger.debug "❌ valid_user NG → redirect"
    redirect_to root_url
  end
end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
