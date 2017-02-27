ActiveAdmin.register Comment do
  permit_params :body, :user_id, :book_id

  filter :user
  filter :book
  filter :body
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :user
    column :book
    column :body
    actions
  end
end
