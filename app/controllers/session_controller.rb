class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_initialize_by(uid: auth.uid, provider: auth.provider)
    if user.new_record?
      user.name      = auth.info.name
      user.nickname  = auth.info.nickname
      user.image_url = auth.info.image
      user.save!
    end
    session[:user_id] = user.id
    redirect_to root_path, notice: 'Xでログインしましたわ！'
  end
  # failure, destroy も同様に実装
end
