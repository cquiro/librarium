# Pundit class to controll authorization for user actions.
class UserPolicy < ApplicationPolicy
  # Signed in users cannot create a new session or a new user.
  def create?
    user.nil?
  end
end
