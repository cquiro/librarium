# Join table to keep track of books a user wishes to read. Belongs to user and
# to book.
class WishlistsController < ApplicationController
  def create
    authorize :wishlist
    current_user.books_to_read << book
    head :ok
  end

  def destroy
    authorize wishlist
    wishlist.destroy
    head :no_content
  end

  private

  def wishlist
    @wishlist ||= Wishlist.find(params[:id])
  end

  def book
    @book ||= Book.find(params[:book_id])
  end
end
