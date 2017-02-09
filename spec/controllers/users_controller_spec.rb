# require 'rails_helper'

# RSpec.describe UsersController, type: :controller do
#   describe "POST #create" do
#     context "when is succesfully created" do
#       before(:each) do
#         @user_attributes = FactoryGirl.attributes_for :user
#         post :create, { user: @user_attirbutes }, format: :json
#       end

#       it "renders the json representation for the user record just created" do
#         user_response = JSON.parse(response.body, symbolize_names: true)
#         expect(user_response[:email]).to eql @user_attributes[:email]
#       end

#       # it { expect(response).to have_http_status(201) }
#     end

#     # context "when is not created" do
#     #   before(:each) do
#     #     @invalid_user_attributes = { name: "Jason Bourne",
#     #                                  password: "123456",
#     #                                  password_reset: "123456" }
#     #     post :create, { user: @invalid_user_attributes }, format: :json
#     #   end

#     #   it "renders errors in json" do
#     #     user_response = JSON.parse(response.body, symbolize_names: true)
#     #     expect(user_response).to have_key(:errors)
#     #   end

#     #   it "renders the json errors on why the user could not be created" do
#     #     user_response = JSON.parse(response.body, symbolize_names: true)
#     #     expect(user_response[:errors][:email]).to include "can't be blank"
#     #   end

#     #   it { expect(response).to have_http_status(422) }
#     # end
#   end
# end
