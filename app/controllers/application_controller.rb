class ApplicationController < ActionController::Base # :nodoc:
  respond_to :json
  protect_from_forgery with: :null_session

  before_action :configure_permited_parameters, if: :devise_controller?

  acts_as_token_authentication_handler_for User, fallback: :none

  protected

  # allow user to sign up with a name
  def configure_permited_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
