class ApplicationController < ActionController::Base # :nodoc:
  respond_to :json, :html
  protect_from_forgery with: :null_session

  include Pundit

  before_action :configure_permited_parameters, if: :devise_controller?

  respond_to :json

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  acts_as_token_authentication_handler_for User, fallback: :none

  protected

  # allow user to sign up with a name
  def configure_permited_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  # return status 401 when pundit authorization fails
  def user_not_authorized
    head :unauthorized
  end

  # return status 404 when a record is not found.
  def record_not_found
    head :not_found
  end
end
