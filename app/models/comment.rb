# Users will be able to comment a book. Each book will be able to have
# many comments about it.
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :book
end
