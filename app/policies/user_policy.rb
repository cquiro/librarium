# Pundit class to control authorization for user actions.
class UserPolicy < ApplicationPolicy
  # Signed in users cannot create a new session or a new user.
  def create?
    user.nil?
  end

  # only a signed in user can see which user are being followed by a given user.
  def following?
    user.present?
  end

  # only a signed in user can see which users follow a given user.
  def followers?
    following?
  end

  def follow?
    following?
  end

  def unfollow?
    following?
  end
end
