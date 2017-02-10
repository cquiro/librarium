class CreateConnections < ActiveRecord::Migration[5.0]
  def change
    create_table :connections do |t|
      t.integer  "user_id"
      t.integer  "followee_id"
      
      t.timestamps
    end
  end
end
