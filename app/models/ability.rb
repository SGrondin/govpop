class Ability
  include CanCan::Ability

  def initialize(user)

    if user.superadmin?
      can :manage, :all
      return
    end

    if user.admin?
      can [:create, :update], Question
      return
    end

  end
end
