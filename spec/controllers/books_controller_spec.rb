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
    context "when is succesfully created" do
      let(:book_attributes) { attributes_for(:book) }
      
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
      let(:invalid_book_attributes) { attributes_for(:book, title: '') }

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
end
