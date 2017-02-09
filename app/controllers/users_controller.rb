# class UsersController < ApplicationController
#   respond_to :json

#   def create
#     user = User.new(user_params)
#     if user.save
#       render json: user, status: 201
#     else
#       render json: { errors: user.errors }, status: 422
#     end
#   end
# end
