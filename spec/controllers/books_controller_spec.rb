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
end
