# app/controllers/users/omniauth_callbacks_controller.rb

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    # Twitter 連携のコールバックを処理
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
    else
      # 保存に失敗した場合はセッションにデータを突っ込んでサインアップ画面へリダイレクト
      session['devise.twitter_data'] = request.env['omniauth.auth'].except(:extra)
      redirect_to new_user_registration_url, alert: 'Twitter の認証に失敗しました…'
    end
  end

  # 必要に応じて他プロバイダ用メソッドを追加
end
