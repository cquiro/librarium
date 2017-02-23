require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let(:book_response) { JSON.parse(response.body, symbolize_names: true) }

  describe "GET #index" do
    before :each do
      create_list(:book, 6)
      get :index
    end

    it "returns 6 records from the database" do
      expect(book_response.count).to eq 6
    end

    it "has a 200 status" do
      expect(response.status).to eq 200
    end
  end

  describe "pagination" do
    before :each do
      create_list(:book, 30)
      get :index, params: { page: 2, per_page: 20 }
    end

    it "returns 10 books with page: 2 and per_page: 20 from 30 books" do
      expect(book_response.count).to eq 10
    end

    it "has status 200" do
      expect(response.status).to eq 200
    end
  end

  describe "GET #show" do
    let(:book) { create(:book) }

    before :each do
      get :show, params: { id: book.id }
    end

    it "returns the book information in json format" do
      expect(book_response[:title]).to eq book.title
    end

    it "has a 200 status code" do
      expect(response.status).to eq 200
    end
  end
  
  describe "POST #create" do
    let(:book_attributes) { attributes_for(:book) }
    let(:invalid_book_attributes) { attributes_for(:book, title: '') }

    context "when user is signed in and is an admin" do
      let(:user) { create(:user, admin: true) }
 
      before :each do
        sign_in user
      end

      context "when is succesfully created" do
        before :each do
          post :create, params: { book: book_attributes }
        end

        it "renders the created book in json format" do
          expect(book_response[:title]).to eq book_attributes[:title]
        end

        it "has a 201 status" do
          expect(response.status).to eq 201
        end
      end

      context "when is not created" do
        before :each do
          post :create, params: { book: invalid_book_attributes }
        end

        it "renders json errors" do
          expect(book_response).to have_key :errors
        end

        it "renders specific errors on why book is not valid" do
          expect(book_response[:errors][:title]).to include "can't be blank"
        end

        it "has a 422 status" do
          expect(response.status).to eq 422
        end
      end
    end

    context "when user is signed in but is not an admin" do
      let(:user) { create(:user, admin: false) }
 
      before :each do
        sign_in user
        post :create, params: { book: book_attributes }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq '' 
      end

      it "returns status code 401" do
        expect(response.status).to eq 401
      end
    end

    context "when user is not signed in" do
      before :each do
        post :create, params: { book: book_attributes }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end

      it "returns status code 401" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "PUT #update" do
    let(:book) { create(:book) }

    context "when user is signed in and is an admin" do
      let(:user) { create(:user, admin: true) }

      before :each do
        sign_in user
      end

      context "when is succesfully updated" do
        before :each do
          put :update, params: { id: book.id, 
                                 book: { edition: 'Second Edition' } }
        end

        it "renders the updated book in json format" do
          expect(book_response[:edition]).to eq 'Second Edition'
        end

        it "has a 200 status" do
          expect(response.status).to eq 200
        end
      end

      context "when is not updated" do
        before :each do
          put :update, params: { id: book.id, 
                                 book: { title: '' } }
        end

        it "renders json errors" do
          expect(book_response).to have_key :errors
        end

        it "renders specific errors on why book is not valid" do
          expect(book_response[:errors][:title]).to include "can't be blank"
        end

        it "has a 422 status" do
          expect(response.status).to eq 422
        end
      end
    end

    context "when user is signed in but is not an admin" do
      let(:user) { create(:user, admin: false) }

      before :each do
        sign_in user
        put :update, params: { id: book.id, 
                               book: { edition: 'Third Edition' } }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end

      it "returns status code 401" do
        expect(response.status).to eq 401
      end
    end

    context "when user is not signed in" do
      before :each do
        put :update, params: { id: book.id, 
                               book: { edition: 'Third Edition' } }
      end
      
      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end

      it "returns status code 401" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "DELETE #destroy" do
    let(:book) { create(:book) }

    context "when user is signed in and is an admin" do
      let(:user) { create(:user, admin: true) }

      before :each do
        sign_in user
        delete :destroy, params: { id: book.id }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end

      it "returns a 204 code" do
        expect(response.status).to eq 204
      end
    end

    context "when user is signed in but is not an admin" do
      let(:user) { create(:user, admin: false) }

      before :each do
        sign_in user
        delete :destroy, params: { id: book.id }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end
      
      it "returns 401 code" do
        expect(response.status).to eq 401
      end
    end

    context "when user is not signed in" do
      before :each do
        delete :destroy, params: { id: book.id }
      end

      it "returns nothing in the response body" do
        expect(response.body).to eq ''
      end

      it "returns 401 status code" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "POST #rate" do
    let(:user) { create(:user) }
    let(:book) { create(:book) }

    context "when user is signed in" do
      before :each do
        sign_in user
      end

      context "the user has not rated this book before" do
        before :each do  
          post :rate, params: { id: book.id, score: 7 }
        end

        it "returns nothing in the response body" do
          expect(response.body).to eq ''
        end

        it "creates a rating that belongs to user" do
          expect(Rating.last.user).to eq user
        end

        it "creates a rating the belongs to book" do
          expect(Rating.last.book).to eq book
        end

        it "creates rating with a score of 7" do
          expect(Rating.last.score).to eq 7
        end

        it "has a 200 status code" do
          expect(response.status).to eq 200
        end
      end

      context "the user had rated the same book before" do
        let!(:rating) { Rating.create(user_id: user.id, book_id: book.id,
                                      score: 5) }

        before :each do  
          post :rate, params: { id: book.id, score: 9 }
        end

        it "returns nothing in the reponse body" do
          expect(response.body).to eq ''
        end

        it "updates the existing rating" do
          expect(user.ratings.find_by(book_id: book.id)).to eq rating
        end

        it "updates the rating to have a score of 9" do
          rating.reload
          expect(rating.score).to eq 9
        end

        it "has a 200 status code" do
          expect(response.status).to eq 200
        end
      end
    end

    context "when user is signed in" do
      before :each do  
        post :rate, params: { id: book.id, score: 7 }
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
