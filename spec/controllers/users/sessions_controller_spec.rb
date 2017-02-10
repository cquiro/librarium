require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe "POST #create" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create :user
    end

    context "when the credentials are correct" do
      before :each do
        credentials = { email: @user.email, password: '123456' }
        post :create, params: { session: credentials }
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        response_token = JSON.parse(response.body)["authentication_token"]
        expect(response_token).to eq @user.authentication_token
      end

      it "has a 200 status" do
        expect(response.status).to eq 200  
      end
    end


    context "when the credentials are incorrect" do
      before :each do
        credentials = { email: @user.email, password: 'invalid_password' }
        post :create, params: { session: credentials }
      end

      it "returns a json with an error" do
        expect(response.body).to include "Invalid email or password"
      end

      it "has a 422 status" do
        expect(response.status).to eq 422  
      end
    end
  end
end
