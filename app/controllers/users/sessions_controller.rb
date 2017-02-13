module Users
  # override devise sessions controller to create a json endpoint.
  class SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token, only: [:create]
    respond_to :json

    # POST /resource/sign_in
    def create
      user = User.find_by(email: session_params[:email])
      if user && user.valid_password?(session_params[:password])
        sign_in user, store: false
        user.save
        render json: user, status: :ok
      elsif !user
        render json: nil, status: :not_found
        # render json: { errors: 'User not found' }, status: :not_found
      else
        render json: nil, status: :unauthorized
        # render json: { errors: 'Invalid password' }, status: :unauthorized
      end
    end

    private

    def session_params
      params.require(:session).permit(:email, :password)
    end
  end
end
