require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user_response) { JSON.parse(response.body, symbolize_names: true) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET #show" do
    context "when the user exists" do
      before :each do
        sign_in user
        get :show, params: { id: user.id }
      end

      it "returns the user information" do
        expect(user_response[:name]).to eq user.name
        expect(user_response[:email]).to eq user.email
        expect(user_response[:admin]).to eq user.admin
      end
    end
    
    context "when the user does not exists" do
      before :each do
        get :show, params: { id: 'not valid' }
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
    before :each do
      sign_in user
    end

    context "when is succesfully updated" do
      before :each do
        put :update, params: { user: { email: 'new@email.com' } }
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
        put :update, params: { user: { email: 'bademail.com' } }
      end

      it "renders json errors" do
        expect(user_response[:errors][:email]).to include 'is invalid'
      end

      it "has a 422 status" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "POST #follow" do
    context "when user is signed in" do
      before :each do
        sign_in user
      end

      context "when user is not already following other_user" do
        before :each do
          post :follow, params: { id: other_user.id }
        end

        it "returns nothing in the response body" do
          expect(response.body).to eq ''
        end

        it "new connection has other user as followee" do
          expect(Connection.last.followee).to eq other_user
        end
        
        it "new connection has current_user as follower" do
          expect(Connection.last.user).to eq user
        end

        it "has a 200 status code" do
          expect(response.status).to eq 200
        end
      end

      context "when user is already following other_user" do
        before :each do
          Connection.create(user_id: user.id, followee_id: other_user.id)
          post :follow, params: { id: other_user.id }
        end

        it "returns nothing in the response body" do
          expect(response.body).to eq ''
        end

        it "has a 412 status code" do
          expect(response.status).to eq 412
        end
      end
    end

    context "when user is not signed in" do
      before :each do
        post :follow, params: { id: other_user.id }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end
      
      it "has a 401 status code" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "DELETE #unfollow" do
    context "when user is signed in" do
      before :each do
        sign_in user
        delete :unfollow, params: { id: other_user.id }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end

      it "has a 204 status code" do
        expect(response.status).to eq 204
      end
    end

    context "when user is not signed in" do
      before :each do
        delete :unfollow, params: { id: other_user.id }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end
      
      it "has a 401 status code" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET #following" do
    context "when the user is signed in" do
      let(:user) { create(:user) }
      let(:user2) { create(:user) }
      let(:user3) { create(:user) }

      before :each do
        Connection.create(user_id: user.id, followee_id: user2.id)
        Connection.create(user_id: user.id, followee_id: user3.id)
        sign_in user
        get :following, params: { id: user.id }
      end

      it "returns the list of users followed by a specified user" do
        expect(user_response.count).to eq 2
      end

      it "has a 200 status code" do
        expect(response.status).to eq 200
      end
    end

    context "when the user is not signed in" do
      before :each do
        get :following, params: { id: user.id }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end
      
      it "has a 401 status code" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET #followers" do
    context "when the user is signed in" do
      let(:user) { create(:user) }
      let(:user2) { create(:user) }
      let(:user3) { create(:user) }

      before :each do
        Connection.create(user_id: user2.id, followee_id: user.id)
        Connection.create(user_id: user3.id, followee_id: user.id)
        sign_in user
        get :followers, params: { id: user.id }
      end

      it "returns the list of users that follow a specified user" do
        expect(user_response.count).to eq 2
      end

      it "has a 200 status code" do
        expect(response.status).to eq 200
      end
    end

    context "when the user is not signed in" do
      before :each do
        get :followers, params: { id: user.id }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end
      
      it "has a 401 status code" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "GET #favorite_books" do
    let(:user) { create(:user) }
    let(:book) { create(:book, title: "Title") }

    before :each do
      Favorite.create(user_id: user.id, book_id: book.id)
      get :favorite_books, params: { id: user.id }
    end

    it "returns the list of books marked as favorite by a user" do
      expect(user_response.count).to eq 1
    end

    it "has a 200 status code" do
      expect(response.status).to eq 200
    end
  end

  describe "GET #books_to_read" do
    let(:user) { create(:user) }
    let(:book) { create(:book, title: 'Title') }

    before :each do
      Wishlist.create(user_id: user.id, book_id: book.id)
      get :books_to_read, params: { id: user.id }
    end

    it "returns the list of books 'wishlisted' by a user" do
      expect(user_response.count).to eq 1
    end

    it "has a 200 status code" do
      expect(response.status).to eq 200
    end
  end
end
