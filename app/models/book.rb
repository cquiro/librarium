# Each book insatance will have many comments.
# A Book instance will have many users through favorites and also
# it will have many users through wishlists.
class Book < ActiveRecord::Base
  has_many :comments
  has_many :favorites
  has_many :wishlists
  has_many :ratings
end
