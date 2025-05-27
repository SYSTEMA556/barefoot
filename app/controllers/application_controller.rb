class ApplicationController < ActionController::Base
  #helper_method :current_user, :logged_in?
    before_action :configure_permitted_parameters, if: :devise_controller?


  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    redirect_to new_session_path unless logged_in?
  end

  

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,        keys: [:user_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_name])
  end
end

