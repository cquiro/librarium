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
end
