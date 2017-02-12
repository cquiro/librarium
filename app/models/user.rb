# The user model will be able to have many followers and also to follow
# several other users. This model is designed to have a self-referential
# association implemented via a self-join table named connections.
class User < ActiveRecord::Base
  # Make user model token authenticatable. This is part of the
  # simple_token_authentication gem configuration.
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :comments
  has_many :favorites
  has_many :wishlists
  has_many :ratings
  has_many :connections, dependent: :destroy
  has_many :followees, through: :connections
  has_many :inverse_connections, class_name: 'Connection',
                                 foreign_key: 'followee_id',
                                 dependent: :destroy
  has_many :followers, through: :inverse_connections, source: :user
  validates :name, :email, presence: true
  validates :password, :password_confirmation,
            presence: true, length: { minimum: 6, maximum: 128 }, on: :create
  validates :password, :password_confirmation,
            length: { minimum: 6, maximum: 128 }, on: :update, allow_blank: true
end
