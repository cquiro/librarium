class AddAvgScoreToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :avg_score, :float
    add_index :books, :avg_score
  end
end
