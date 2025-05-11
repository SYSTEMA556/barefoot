class UserMailer < ApplicationMailer
  def email_confirmation(user)
    @user = user
    mail to: @user.email, subject: "メール認証をお願いします"
  end
end