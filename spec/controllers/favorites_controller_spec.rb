require 'rails_helper'

RSpec.describe FavoritesController, type: :controller do
  let(:favorite_response) { JSON.parse(response.body, symbolize_names: true) }
  let(:other_user) { create(:user) }
  let(:admin_user) { create(:user, admin: true) }

  describe "POST #create" do
    let(:user) { create(:user) }
    let(:book) { create(:book) }

    context "when user is signed in" do
      before :each do
        sign_in user
      end

      context "when book has not been previously favorited" do
        before :each do
          post :create, params: { book_id: book.id }
        end

        it "returns nothing in the response body" do
          expect(response.body).to eq '' 
        end

        it "has a 200 status code" do
          expect(response.status).to eq 200
        end

        it "belongs_to user" do
          expect(Favorite.last.user_id).to eq user.id
        end

        it "belongs_to book" do
          expect(Favorite.last.book_id).to eq book.id
        end

        it "creates a new notification that belongs to new favorite" do
          expect(Notification.last.notifiable_type).to eq "Favorite"
          expect(Notification.last.notifiable_id).to eq Favorite.last.id
        end

        it "create a notification that belongs to user that favorites" do
          expect(Notification.last.notifier_id).to eq user.id
        end
      end

      context "when book has been previously favorited" do
        before :each do
          Favorite.create(user_id: user.id, book_id: book.id)
          post :create, params: { book_id: book.id }
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
        post :create, params: { book_id: book.id }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end

      it "has a 401 status code" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "DELETE #destroy" do
    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:favorite) { Favorite.create(user_id: user.id, book_id: book.id) }

    context "when user is signed in" do
      context "owns the favorite" do
        before :each do
          sign_in user
          delete :destroy, params: { book_id: book.id, id: favorite.id }
        end

        it "returns nothing in the response body" do
          expect(response.body).to eq ''
        end

        it "has 204 status code" do
          expect(response.status).to eq 204
        end
      end

      context "does not own the favorite" do
        context "is not and admin" do
          before :each do
            sign_in other_user
            delete :destroy, params: { book_id: book.id, id: favorite.id }
          end

          it "returns nothing in the response body" do
            expect(response.body).to eq ''
          end

          it "has a 401 status code" do
            expect(response.status).to eq 401
          end
        end

        context "is an admin" do
          before :each do
            sign_in admin_user
            delete :destroy, params: { book_id: book.id, id: favorite.id }
          end

          it "returns nothing in the response body" do
            expect(response.body).to eq ''
          end

          it "returns a 204 status code" do
            expect(response.status).to eq 204
          end
        end
      end
    end

    context "when user is not signed in" do
      before :each do
        delete :destroy, params: { book_id: book.id, id: favorite.id }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end

      it "has a 401 status code" do
        expect(response.status).to eq 401
      end
    end
  end
end
