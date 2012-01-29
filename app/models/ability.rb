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
      can :index, User
      can :edit, User, :id => @user.id
    when "reader"
      can :view, Fortune, :published => true
      can :view, Headline, :published => true
      can :edit, User, :id => @user.id
    end
  end

  def can_manage_self
  end
end
