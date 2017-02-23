# Controller to handle book management
class BooksController < ApplicationController
  before_action :authorization, except: [:show, :index]

  def show
    render json: book, status: :ok
  end

  def index
    books = Book.search(params).page(params[:page]).per(params[:per_page])
    render json: books, status: :ok
  end

  def create
    book = Book.new(book_params)
    if book.save
      render json: book, status: :created
    else
      render json: { errors: book.errors }, status: :unprocessable_entity
    end
  end

  def update
    if book.update(book_params)
      render json: book, status: :ok
    else
      render json: { errors: book.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    book.destroy
    head :no_content
  end

  def rate
    rating.update_attributes(score: params[:score])
    head :ok
  end

  private

  def authorization
    authorize :book
  end

  def rating
    @rating ||= current_user.ratings.find_or_create_by(book_id: book.id)
  end

  def book
    @book ||= Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :pub_date, :genre, :cover,
                                 :synopsis, :language, :edition, :publisher,
                                 :avg_score)
  end
end
