# This is a self join table. It is meant to allow users to follow each
# other and get notified of each others activities. It is meant to
# implement self-referential association.
class Connection < ActiveRecord::Base
  belongs_to :user
  belongs_to :followee, class_name: 'User'
  has_many :notifications, as: :notifiable
  validates :user_id, :followee_id, presence: true
end
