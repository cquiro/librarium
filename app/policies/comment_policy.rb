# Pundit class to control authorization for comment actions.
class CommentPolicy < ApplicationPolicy
  # only signed up users can comment a book
  def create?
    user.present?
  end

  # only signed up users can update a comment
  def update?
    user.present? && (user.admin? || user == @resource.user)
  end

  # only signed in users can delete their comments
  def destroy?
    update?
  end
end
