# Pundit class to control authorization for user actions.
class UserPolicy < ApplicationPolicy
  # Signed in users cannot create a new session or a new user.
  def create?
    user.nil?
  end

  def follow?
    user.present?
  end

  def unfollow?
    follow?
  end
end
