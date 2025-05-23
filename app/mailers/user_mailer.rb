class UserMailer < ApplicationMailer
  def confirmation_email
    @user = params[:user]
    @url  = confirm_email_url(token: @user.confirmation_token)
    mail(to: @user.email, subject: '【ご確認ください】メールアドレス認証のお願い')
  end
  def password_reset(user)
    @user = user
  mail to: user.email, subject: "【ご確認ください】メールアドレス認証のお願い'"
  end
end
