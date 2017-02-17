module Users
  # override devise sessions controller to create a json endpoint.
  class SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token, only: [:create]
    respond_to :json

    # POST /resource/sign_in
    def create
      authorize :user
      user = User.find_by(email: session_params[:email])
      if user && user.valid_password?(session_params[:password])
        sign_in user, store: false
        render json: user, status: :ok
      else
        user.nil? ? (status = :not_found) : (status = :unauthorized)
        render nothing: true, status: status
      end
    end

    private

    def session_params
      params.require(:session).permit(:email, :password)
    end
  end
end
