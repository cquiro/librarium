module Users
  # override devise sessions controller to create a json endpoint.
  class SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token, only: [:create]
    respond_to :json

    # POST /resource/sign_in
    def create
      user_password = params[:session][:password]
      user_email = params[:session][:email]
      user = user_email.present? && User.find_by(email: user_email)

      if user && user.valid_password?(user_password)
        sign_in user, store: false
        user.save
        render json: user, status: 200
      else
        render json: { errors: 'Invalid email or password' }, status: 422
      end
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
