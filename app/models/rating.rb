# Users can give a score to any book. A book can have many ratings.
class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  validates :score, :user_id, :book_id, presence: true
end
