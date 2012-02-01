class UsersController < ApplicationController
  before_filter :fetch_user, :except => [:index]

  def index
    @meta_tags[:title] = "Users"
    @users = User.all
    authorize! :index, User
  end

  def edit
    @meta_tags[:title] = "Edit User"
    authorize! :edit, @user
  end

  def show
    @meta_tags[:title] = "Users | #{@user.display_name}"
    New Fortune
    authorize! :view, @user
  end

  def update
    authorize! :edit, @user
    if @user.update_attributes filtered_params
      flash[:notice] = "User '#{@user.email}' was successfully updated."
      redirect_to users_path
    else
      render :action => "edit"
    end
  end

  private

  def fetch_user
    @user = User.find params[:id]
  end

  def filtered_params
    ParamFilter.new(params[:user]).filter_empty_passwords
  end
end
