class AddIndexesToConnections < ActiveRecord::Migration[5.0]
  def change
    add_index :connections, :user_id
    add_index :connections, :followee_id
    add_index :connections, [:user_id, :followee_id], unique: true
  end
end
