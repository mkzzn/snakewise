class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    case @user.role
    when "admin"
      can :manage, :all
    when "reader"
      can :view, Fortune, :published => true
      can_manage_self
      can :create, Comment
      can_delete_own_comment
    end
  end

  def can_manage_self
    can [:manage], User, ["id = ?", @user.id] do |current_user|
      current_user.id == @user.id
    end
  end

  def can_delete_own_comment
    can [:delete], Comment do |comment|
      comment.user_id == @user.id and not comment.user_id.nil?
    end
  end
end
