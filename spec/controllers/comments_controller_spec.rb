require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:comment_response) { JSON.parse(response.body, symbolize_names: true) }
  let(:admin_user) { create(:user, admin: true) }
  let(:other_user) { create(:user) }

  describe "GET #show" do
    let(:comment) { create(:comment) }

    before :each do
      get :show, params: { book_id: comment.book.id, id: comment.id }
    end

    it "returns the comment in json format" do
      expect(comment_response[:body]).to eq comment.body
    end

    it "has a 200 status code" do
      expect(response.status).to eq 200
    end
  end

  describe "GET #index" do
    let(:book_1) { create(:book) }
    let(:book_2) { create(:book) }

    before :each do
      create_list(:comment, 4, book_id: book_1.id)
      create_list(:comment, 2, book_id: book_2.id)
      get :index, params: { book_id: book_1.id }
    end

    it "returns all comments for a specific book" do
      expect(comment_response.count).to eq 4
    end

    it "returns status code 200" do
      expect(response.status).to eq 200
    end
  end

  describe "POST #create" do
    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:comment_attributes) { attributes_for(:comment) }

    context "when user is signed in" do
      before :each do
        sign_in user
      end

      context "when is succesfully created" do
        before :each do
          post :create, params: { book_id: book.id,
                                  comment: comment_attributes }
        end

        it "renders the comment in json format" do
          expect(comment_response[:body]).to eq comment_attributes[:body]
        end

        it "belongs to user" do
          expect(comment_response[:user_id]).to eq user.id
        end

        it "belongs to book" do
          expect(comment_response[:book_id]).to eq book.id
        end

        it "has a 200 status code" do
          expect(response.status).to eq 200
        end
      end

      context "when is not created" do
        let(:invalid_comment_attributes) { attributes_for(:comment, body: '') }

        before :each do
          post :create, params: { book_id: book.id,
                                  comment: invalid_comment_attributes }    
        end

        it "renders json errors" do
          expect(comment_response).to have_key :errors
        end
        
        it "renders specific errors on why the comment is not valid" do
          expect(comment_response[:errors][:body]).to include "can't be blank"
        end

        it "has a 422 status code" do
          expect(response.status).to eq 422
        end
      end
    end

    context "when user is not signed in" do
      before :each do
        post :create, params: { book_id: book.id,
                                comment: comment_attributes }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end

      it "has a 401 status code" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "PUT #update" do
    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:comment) { create(:comment, book_id: book.id, user_id: user.id) }

    context "when user is signed in" do
      context "owns the comment" do
        before :each do
          sign_in user
        end

        context "is succesfully updated" do
          before :each do
            put :update, params: { book_id: book.id, id: comment.id,
                                  comment: { body: 'corrected opinion' } }
          end 

          it "renders the updated comment in json format" do
            expect(comment_response[:body]).to eq 'corrected opinion'
          end

          it "has a 200 status code" do
            expect(response.status).to eq 200
          end
        end
        
        context "is not updated" do
          before :each do
            put :update, params: { book_id: book.id, id: comment.id,
                                  comment: { body: '' } }
          end 

          it "renders json errors" do
            expect(comment_response).to have_key :errors
          end

          it "returns the specific error" do
            expect(comment_response[:errors][:body]).to include "can't be blank"
          end

          it "has a 422 status code" do
            expect(response.status).to eq 422
          end
        end
      end

      context "when user does not own the comment" do
        context "is not an admin" do
          before :each do
            sign_in other_user
            put :update, params: { book_id: book.id, id: comment.id,
                                  comment: { body: 'corrected opinion' } }
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
            put :update, params: { book_id: book.id, id: comment.id,
                                  comment: { body: 'corrected opinion' } }
          end 

          it "renders the updated comment in json format" do
            expect(comment_response[:body]).to eq 'corrected opinion'
          end

          it "has a 200 status code" do
            expect(response.status).to eq 200
          end
        end
      end
    end

    context "when user is not signed in" do
      before :each do
        put :update, params: { book_id: book.id, id: comment.id,
                               comment: { body: 'corrected opinion' } }
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
    let!(:comment) { create(:comment, book_id: book.id, user_id: user.id) }

    context "when user is signed in" do
      context "owns the comment" do
        before :each do
          sign_in user
          delete :destroy, params: { book_id: book.id, id: comment.id }
        end

        it "returns nothing in the response body" do
          expect(response.body).to eq ''
        end

        it "returns a 204 status code" do
          expect(response.status).to eq 204
        end
      end

      context "does not own the comment" do
        context "is not and admin" do
          before :each do
            sign_in other_user
            delete :destroy, params: { book_id: book.id, id: comment.id }
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
            delete :destroy, params: { book_id: book.id, id: comment.id }
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
        delete :destroy, params: { book_id: book.id, id: comment.id }
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
