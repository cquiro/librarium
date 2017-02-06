# Each book insatance will have many comments.
# A Book instance will have many users through favorites and also
# it will have many users through wishlists.
class Book < ApplicationRecord
  has_many :comments
  has_many :favorites
  has_many :wishlists
end
