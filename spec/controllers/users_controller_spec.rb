require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:user_response) { JSON.parse(response.body, symbolize_names: true) }

  describe "GET #show" do
    context "when the user exists" do
      before :each do
        sign_in user
      end

      it "returns the user information" do
        get :show, params: { id: user.id }, format: :json

        expect(user_response[:name]).to eq user.name
        expect(user_response[:email]).to eq user.email
        expect(user_response[:admin]).to eq user.admin
      end
    end
    
    context "when the users does not exists" do
      before :each do
        get :show, params: { id: 'not valid' }, format: :json
      end
      
      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end

      it "returns status code 404" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "PUT #update" do
    context "when is succesfully updated" do
      before :each do
        sign_in user
        put :update, params: { user: { email: 'new@email.com' } }, format: :json
      end

      it "renders the updated user in json format" do
        expect(user_response[:email]).to eq 'new@email.com'
      end

      it "has a 200 status" do
        expect(response.status).to eq 200  
      end
    end

    context "when it is not updated" do
      before :each do
        sign_in user
        put :update, params: { user: { email: 'bademail.com' } }, format: :json
      end

      it "renders json errors" do
        expect(user_response[:errors][:email]).to include 'is invalid'
      end

      it "has a 422 status" do
        expect(response.status).to eq 422
      end
    end
  end
end
