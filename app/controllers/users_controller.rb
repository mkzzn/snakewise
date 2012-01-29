class UsersController < ApplicationController
  before_filter :fetch_user, :except => [:index]

  def index
    @users = User.all
    authorize! :index, User
  end

  def edit
    authorize! :edit, @user
  end

  def show
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
