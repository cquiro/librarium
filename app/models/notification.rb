# User has many notifications. Favorite, wishlist and comment have many
# notifications as notifiable.
class Notification < ActiveRecord::Base
  belongs_to :notifier, class_name: 'User'
  belongs_to :notifiable, polymorphic: true
end
