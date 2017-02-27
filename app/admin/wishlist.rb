ActiveAdmin.register Wishlist do
  permit_params :user_id, :book_id

  filter :user
  filter :book
  filter :created_at

  index do
    selectable_column
    column :id
    column :user
    column :book
    actions
  end
end
