# The user model will be able to have many followers and also to follow
# several other users. This model is designed to have a self-referential
# association implemented via a self-join table named connections.
class User < ApplicationRecord
  has_many :comments
  has_many :favorites
  has_many :wishlists
  has_many :connections
  has_many :followees, through: :connections
  has_many :inverse_connections, class_name: 'Connection',
                                 foreign_key: 'followee_id'
  has_many :followers, through: :inverse_connections, source: :user
end
