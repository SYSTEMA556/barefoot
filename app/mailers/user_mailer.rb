class UserMailer < ApplicationMailer
  def email_confirmation(user)
    @user = user
    mail to: @user.email,
         subject: "【#{Rails.application.class.module_parent_name}】メールアドレス確認のご案内"
  end
end
