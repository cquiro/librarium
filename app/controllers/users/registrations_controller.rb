module Users
  # Override RegistrationsController to build a registration endpoint
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :verify_authenticity_token, only: [:create]
    respond_to :json

    # POST /resource
    def create
      build_resource(user_params)
      authorize resource
      if resource.save
        render json: resource, status: :created
      else
        render json: { errors: resource.errors }, status: :unprocessable_entity
      end
    end

    protected

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  end
end
