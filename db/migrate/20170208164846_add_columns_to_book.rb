class AddColumnsToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :cover, :string
    add_column :books, :synopsis, :string
    add_column :books, :language, :string
    add_column :books, :edition, :string
    add_column :books, :publisher, :string
  end
end
