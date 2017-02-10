class AddBookIdToRatings < ActiveRecord::Migration[5.0]
  def change
    add_reference :ratings, :book, foreign_key: true
  end
end
