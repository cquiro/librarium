# Pundit class to control authorization for favorite actions.
class FavoritePolicy < ApplicationPolicy
  # only signed in users can favorite a book
  def create?
    user.present?
  end

  # only signed in users can delete their favorites
  def destroy?
    user.present? && (user.admin? || user == @resource.user)
  end
end
