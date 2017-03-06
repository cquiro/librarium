require 'rails_helper'

RSpec.describe WishlistsController, type: :controller do
  let(:wishlist_response) { JSON.parse(response.body, symbolize_names: true) }
  let(:other_user) { create(:user) }
  let(:admin_user) { create(:user, admin: true) }

  describe "POST #create" do
    let(:user) { create(:user) }
    let(:book) { create(:book) }

    context "when user is signed in" do
      before :each do
        sign_in user
        post :create, params: { book_id: book.id }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq '' 
      end

      it "has a 200 status code" do
        expect(response.status).to eq 200
      end

      it "belongs_to user" do
        expect(Wishlist.last.user_id).to eq user.id
      end

      it "belongs_to book" do
        expect(Wishlist.last.book_id).to eq book.id
      end
 
      it "creates a new notification that belongs to new wishlist" do
        expect(Notification.last.notifiable_type).to eq "Wishlist"
        expect(Notification.last.notifiable_id).to eq Wishlist.last.id
      end

      it "create a notification that belongs to user that wishlists" do
        expect(Notification.last.notifier_id).to eq user.id
      end
    end

    context "when the user is not signed in" do
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
    let(:wishlist) { Wishlist.create(user_id: user.id, book_id: book.id) }

    context "when user is signed in" do
      context "owns the wishlist" do
        before :each do
          sign_in user
          delete :destroy, params: { book_id: book.id, id: wishlist.id }
        end

        it "returns nothing in the response body" do
          expect(response.body).to eq ''
        end

        it "has 204 status code" do
          expect(response.status).to eq 204
        end
      end

      context "does not own the wishlist" do
        context "is not and admin" do
          before :each do
            sign_in other_user
            delete :destroy, params: { book_id: book.id, id: wishlist.id }
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
            delete :destroy, params: { book_id: book.id, id: wishlist.id }
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
        delete :destroy, params: { book_id: book.id, id: wishlist.id }
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
