ActiveAdmin.register Rating do
  permit_params :score, :user_id, :book_id

  index do
    selectable_column
    column :id
    column :user
    column :book
    column :score
    actions
  end
end
