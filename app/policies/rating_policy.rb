# Pundit class to control authorization for rating actions.
class RatingPolicy < ApplicationPolicy
  # only signed in users can rate a book
  def create?
    user.present?
  end

  # only signed in users can update a rating
  def update?
    user.present?
  end

  # only signed in users can delete their ratings
  def destroy?
    user.present?
  end
end
