class HeadlinesController < ApplicationController
  before_filter :fetch_headline, :only => [:show, :update, :edit, :destroy]

  def index
    if can? :manage, Headline
      @headlines = Headline.order "created_at desc"
    else 
      @headlines = Headline.published.order "created_at desc"
    end

    @meta_tags[:title] = "Headlines"

    respond_to do |format|
      format.html     # index.html.erb
      format.xml  { render :xml => @headlines }
    end
  end

  def show
    @meta_tags[:title] = "#{@headline[:headline]}"
    authorize! :view, @headline
    # @comments = @headline.comments
    # @comment = Comment.new :headline_id => @headline.id
  end

  def search
    if can? :manage, Headline
      @headlines = Headline.search params[:keyword]
    else
      @headlines = Headline.search params[:keyword], :conditions => 
        { :published => true }
    end
  end

  def edit
    @meta_tags[:title] = "Edit Headline"
    authorize! :edit, @headline
  end

  def feed
    @headlines = Headline.published.order("created_at desc").limit(10)
    respond_to do |format|
      format.atom
    end
  end

  def create
    authorize! :create, Headline
    @headline = Headline.create params[:headline].merge(:user_id => current_user[:id])
    if @headline.valid?
      flash[:notice] = "Headline was successfully created."
      redirect_to headlines_path
    else
      flash[:warning] = "Headline creation failed"
      render :action => "new"
    end
  end

  def update
    authorize! :update, @headline
    @headline.update_attributes params[:headline]
    if @headline.valid?
      flash[:notice] = "Headline was saved successfully."
      redirect_to(headline_path(@headline))
    else
      render :action => "new"
    end
  end

  def new
    @meta_tags[:title] = "New Headline"
    authorize! :build, Headline
    @headline = Headline.new
  end

  def destroy
    authorize! :destroy, @headline
    @headline.destroy
    flash[:notice] = "Headline was successfully destroyed."
    redirect_to headlines_path
  end

  protected
  def fetch_headline
    @headline = Headline.find params[:id]
  end
end
