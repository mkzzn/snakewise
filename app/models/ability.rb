class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    case @user.role
    when "admin"
      can :manage, :all
    when "writer"
      can :manage, Fortune
      can :manage, Headline
      can :view, User
      can_manage_self
    when "reader"
      can :view, Fortune, :published => true
      can :view, Headline, :published => true
      can_manage_self
    end
  end

  def can_manage_self
    can [:manage], User, ["id = ?", @user.id] do |current_user|
      current_user.id == @user.id
    end
  end
end
