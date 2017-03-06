# Users will be able to comment a book. Each book will be able to have
# many comments about it.
class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :book
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates :body, :user_id, :book_id, presence: true
  after_create :notify

  private

  def notify
    notifications.create(notifier_id: user.id)
  end
end
