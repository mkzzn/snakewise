class CategoriesController < ApplicationController
  def index
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.create params[:category]
    
    if @category.valid?
      redirect_to categories_path
    else
      render :action => "new"
    end
  end

  def edit
  end

end
