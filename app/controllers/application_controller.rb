class ApplicationController < ActionController::Base
 before_action :configure_permitted_parameters, if: :devise_controller?
 before_action :require_age_verification

private
def require_age_verification
  exempt = request.path.start_with?("/gate") || devise_controller?
  return if exempt || cookies.signed[:adult_verified]

  session[:return_to] = request.fullpath
  redirect_to "/gate"
end
  protected
  def configure_permitted_parameters
    attrs = %i[user_name email password password_confirmation]
    devise_parameter_sanitizer.permit :sign_up,        keys: attrs
    devise_parameter_sanitizer.permit :account_update, keys: attrs
  end
end