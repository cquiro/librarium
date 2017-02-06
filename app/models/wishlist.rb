# Users will be able to mark books they want to read later. This is a join
# table to allow users to have a wishlist of many books they would like to
# read later and books to have many users that would like to read them.
# Wishlist will be a join table for a many to many association.
class Wishlist < ApplicationRecord
  belongs_to :user
  belongs_to :book
end
