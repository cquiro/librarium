# Users controller to manage show and update actions.
class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]

  def show
    user = User.find(params[:id])
    render json: user, status: :ok
  end

  def update
    if current_user.update_attributes(user_params)
      render json: current_user, status: :ok
    else
      render json: { errors: current_user.errors },
             status: :unprocessable_entity
    end
  end

  def follow
    authorize :user

    return head :precondition_failed if following(user)

    current_user.followees << user
    head :ok
  end

  def unfollow
    authorize :user
    current_user.followees.delete(user)
    head :no_content
  end

  private

  def following(user)
    current_user.followees.include?(user)
  end

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
