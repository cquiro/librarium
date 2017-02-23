# Join table to keep track of favorite books. Belong to user and to book.
class FavoritesController < ApplicationController
  def create
    authorize :favorite

    return head :precondition_failed if favorited(book)

    current_user.favorite_books << book
    head :ok
  end

  def destroy
    authorize favorite
    favorite.destroy
    head :no_content
  end

  private

  def favorited(book)
    current_user.favorite_books.include?(book)
  end

  def favorite
    @favorite ||= Favorite.find(params[:id])
  end

  def book
    @book ||= Book.find(params[:book_id])
  end
end
