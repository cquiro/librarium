# Users controller to manage show and update actions.
class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]
  respond_to :json

  def show
    user = User.find(params[:id])
    render json: user
  end

  def update
    user = current_user
    if user.update_attributes(user_params)
      render json: user, status: :ok
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
