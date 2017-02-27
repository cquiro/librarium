ActiveAdmin.register Connection do
  permit_params :user_id, :followee_id

  filter :user
  filter :followee
  filter :created_at

  index do
    selectable_column
    column :id
    column 'Follower', :user
    column 'Following', :followee
    actions
  end
end
