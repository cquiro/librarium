# Controller to handle book management
class BooksController < ApplicationController
  def index
    books = Book.search(params).page(params[:page]).per(params[:per_page])
    render json: books, status: :ok
  end
end
