class ChangeBackColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :admin?, :admin
  end
end
