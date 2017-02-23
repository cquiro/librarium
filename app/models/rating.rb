# Users can give a score to any book. A book can have many ratings.
class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  validates :score, :user_id, :book_id, presence: true

  after_save :update_book_avg_score
  after_destroy :update_book_avg_score

  def update_book_avg_score
    book.calculate_avg_score
  end
end
