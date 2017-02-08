class ApplicationController < ActionController::Base # :nodoc:
  protect_from_forgery with: :exception

  before_action :configure_permited_parameters, if: :devise_controller?

  protected

  # allow user to sign up with a name
  def configure_permited_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
