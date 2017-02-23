# Pundit class to control authorization for connection actions.
class ConnectionPolicy < ApplicationPolicy
  # only signed in users can follow other users.
  def create?
    user.present?
  end

  # only signed in users can delete unfollow other users.
  def destroy?
    user.present?
  end
end
