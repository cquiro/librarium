# Users will be able to mark books as favorites. This is a join table
# to allow users to have many favorite books and books to have many
# users that like them. Favorites will be a join table for a many to many
# association.
class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  has_many :notifications, as: :notifiable
end
