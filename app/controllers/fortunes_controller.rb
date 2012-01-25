class FortunesController < ApplicationController
  before_filter :fetch_fortune, :only => [:show, :update, :edit, :destroy]

  def index
    if can? :manage, Fortune
      @fortunes = Fortune.order "created_at desc"
    else 
      @fortunes = Fortune.published.order "created_at desc"
    end

    respond_to do |format|
      format.html     # index.html.erb
      format.xml  { render :xml => @fortunes }
    end
  end

  def show
    authorize! :view, @fortune
    # @comments = @fortune.comments
    # @comment = Comment.new :fortune_id => @fortune.id
  end

  def search
    if can? :manage, Fortune
      @fortunes = Fortune.search params[:keyword]
    else
      @fortunes = Fortune.search params[:keyword], :conditions => 
        { :published => true }
    end
  end

  def edit
    authorize! :edit, @fortune
  end

  def feed
    @fortunes = Fortune.published.order("created_at desc").limit(10)
    respond_to do |format|
      format.atom
    end
  end

  def create
    authorize! :create, Fortune
    @fortune = Fortune.create params[:fortune].merge(:user_id => current_user[:id])
    if @fortune.valid?
      flash[:notice] = "Fortune was successfully created."
      redirect_to fortunes_path
    else
      flash[:warning] = "Fortune creation failed"
      render :action => "new"
    end
  end

  def update
    authorize! :update, @fortune
    @fortune.update_attributes params[:fortune]
    if @fortune.valid?
      flash[:notice] = "Fortune was saved successfully."
      redirect_to(fortune_path(@fortune))
    else
      render :action => "new"
    end
  end

  def new
    authorize! :build, Fortune
    @fortune = Fortune.new
  end

  def destroy
    authorize! :destroy, @fortune
    @fortune.destroy
    flash[:notice] = "Fortune was successfully destroyed."
    redirect_to fortunes_path
  end

  protected
  def fetch_fortune
    @fortune = Fortune.find params[:id]
  end
end
