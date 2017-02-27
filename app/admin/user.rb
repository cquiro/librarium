ActiveAdmin.register User do
  permit_params :name, :email, :password, :password_confirmation, :admin

  filter :name
  filter :email
  filter :admin
  filter :created_at
  filter :favorite_books
  filter :books_to_read
  filter :followees
  filter :followers

  index do
    selectable_column
    column :id
    column :name
    column :email
    column :admin
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin, label: 'Administrator'
    end
    actions
  end
end
