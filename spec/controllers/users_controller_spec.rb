require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #show" do
    let(:user) { create(:user) }

    before :each do
      sign_in user
      get :show, params: { id: user.id }, format: :json
    end
    
    it "returns the user information" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:name]).to eq user.name
      expect(user_response[:email]).to eq user.email
      expect(user_response[:admin]).to eq user.admin
    end
  end

  describe "PATCH #update" do
    let(:user) { create(:user) }

    context "when is succesfully updated" do
      before :each do
        sign_in user
        patch :update, params: { id: user.id,
                                 user: { email: 'new@email.com' } }, 
                                 format: :json
      end

      it "renders the updated json user in json format" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq 'new@email.com'
      end

      it "has a 200 status" do
        expect(response.status).to eq 200  
      end
    end

    context "when it is not updated" do
      before :each do
        sign_in user
        patch :update, params: { id: user.id,
                                 user: { email: 'bademail.com' } },
                                 format: :json
      end

      it "renders json errors" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include 'is invalid'
      end

      it "has a 422 status" do
        expect(response.status).to eq 422
      end
    end
  end
end
