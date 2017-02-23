# Users controller to manage show and update actions.
class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]
  before_action :authorization, only: [:follow, :unfollow,
                                       :following, :followers]

  def show
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
    return head :precondition_failed if follows(user)

    current_user.followees << user
    head :ok
  end

  def unfollow
    current_user.followees.delete(user)
    head :no_content
  end

  def following
    following = user.followees
    render json: following, status: :ok
  end

  def followers
    followers = user.followers
    render json: followers, status: :ok
  end

  def favorite_books
    books = user.favorite_books
    render json: books, status: :ok
  end

  def books_to_read
    books = user.books_to_read
    render json: books, status: :ok
  end

  private

  def authorization
    authorize :user
  end

  def follows(user)
    current_user.followees.include?(user)
  end

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
