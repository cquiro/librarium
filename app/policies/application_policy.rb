# Generic initializer. Other pundit class policies will inherit form this one.
class ApplicationPolicy
  attr_reader :user, :resource

  def initialize(user, resource)
    @user = user
    @resource = resource
  end
end
