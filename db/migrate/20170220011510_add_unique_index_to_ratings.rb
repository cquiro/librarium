class AddUniqueIndexToRatings < ActiveRecord::Migration[5.0]
  def change
    add_index :ratings, [:user_id, :book_id], unique: true
  end
end
