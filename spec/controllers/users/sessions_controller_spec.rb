require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe "POST #create" do
    let(:response_token) { JSON.parse(response.body)["authentication_token"] }
    let(:user) { create(:user) }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    context "when the credentials are correct" do
      before :each do
        credentials = { email: user.email, password: '123456' }
        post :create, params: { session: credentials }
      end

      it "returns the user record corresponding to the given credentials" do
        user.reload
        expect(response_token).to eq user.authentication_token
      end

      it "has a 200 status" do
        expect(response.status).to eq 200  
      end
    end


    context "when the credentials are incorrect" do
      context "with incorrect password" do
        before :each do
          credentials = { email: user.email, password: 'invalid_password' }
          post :create, params: { session: credentials }
        end

        it "returns nothing" do
          expect(response.body).to eq '' 
        end

        it "has a 401 unauthorized status" do
          expect(response.status).to eq 401  
        end
      end

      context "with incorrect email" do
        before :each do
          credentials = { email: 'incorrect_email', password: '123456' }
          post :create, params: { session: credentials }
        end

        it "returns nothing" do
          expect(response.body).to eq ''
        end

        it "has a 404 not_found status" do
          expect(response.status).to eq 404  
        end
      end
    end
  end
end
