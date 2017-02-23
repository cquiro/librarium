# Pundit class to control authorization for wishlists actions.
class WishlistPolicy < ApplicationPolicy
  # only signed in users can add a book to a wishlist
  def create?
    user.present?
  end

  # only signed in users can delete a book from a wishlist
  def destroy?
    user.present? && (user.admin? || (user == @resource.user))
  end
end
