class UserMailer < ApplicationMailer
  default from: 'your_email@gmail.com'

  def email_confirmation(user)
    @user = user
    # confirm_email_users_url はルーティングに合わせて
    @url  = confirm_email_users_url(token: @user.email_token)
    mail(to: @user.email, subject: '【紅魔館】仮登録ありがとうございます')
  end
end
