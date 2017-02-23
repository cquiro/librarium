# Pundit class to control authorization for book actions.
class BookPolicy < ApplicationPolicy
  # only admin users can create, update or destroy a book.
  def create?
    user.present? && user.admin?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def rate?
    user.present?
  end
end
