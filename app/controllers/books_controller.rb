# Controller to handle book management
class BooksController < ApplicationController
  def show
    book = Book.find(params[:id])
    render json: book, status: :ok
  end

  def index
    books = Book.search(params).page(params[:page]).per(params[:per_page])
    render json: books, status: :ok
  end

  def create
    authorize :book
    book = Book.new(book_params)
    if book.save
      render json: book, status: :created
    else
      render json: { errors: book.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize :book
    book = Book.find(params[:id])
    if book.update(book_params)
      render json: book, status: :ok
    else
      render json: { errors: book.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize :book
    book = Book.find(params[:id])
    book.destroy
    head :no_content
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :pub_date, :genre, :cover,
                                 :synopsis, :language, :edition, :publisher,
                                 :avg_score)
  end
end
