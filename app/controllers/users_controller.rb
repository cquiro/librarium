# Users controller to manage show and update actions.
class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]

  def show
    user = User.find(params[:id])
    render json: user
  end

  def update
    if current_user.update_attributes(user_params)
      render json: current_user, status: :ok
    else
      render json: { errors: current_user.errors },
             status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
