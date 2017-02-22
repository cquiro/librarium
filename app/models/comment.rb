# Users will be able to comment a book. Each book will be able to have
# many comments about it.
class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  has_many :notifications, as: :notifiable

  validates :body, presence: true
end
