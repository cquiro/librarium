# Users will be able to mark books as favorites. This is a join table
# to allow users to have many favorite books and books to have many
# users that like them. Favorites will be a join table for a many to many
# association.
class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates :user_id, :book_id, presence: true
  after_create :notify

  private

  def notify
    notifications.create(notifier_id: user.id)
  end
end
