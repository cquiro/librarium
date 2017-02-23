class AddUniqueIndexToWishlists < ActiveRecord::Migration[5.0]
  def change
    add_index :wishlists, [:user_id, :book_id], unique: true
  end
end
