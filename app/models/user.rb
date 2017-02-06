class User < ApplicationRecord
  has_many :comments
  has_many :favorites
  has_many :wishlists
end
