require 'spec_helper'

describe ArticlesController do
  before(:each) do
    @attributes = {"title" => "excellent", "body" => "nonsense"}
  end

  describe "GET 'index'" do
    it "should return available articles" do
      Article.should_receive(:all) { mock_article @attributes }
    end

    after(:each) do
      get 'index'
    end
  end

  describe "GET 'uncategorized'" do
    before(:each) do
      @article1 = mock_article :category_id => 1
      @article2 = mock_article :category_id => nil
    end

    it "should return only uncategorized articles" do
      Article.should_receive(:uncategorized) { [ @article2 ] }
      get 'uncategorized'
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @article = mock_article
      Article.stub!(:find) { @article }
      stub_current_ability
    end

    context "user can delete articles" do
      before(:each) do
        @ability.can :destroy, Article
      end

      it "should find the article" do
        Article.should_receive(:find).with(2) { @article }
        delete 'destroy', :id => 2
      end

      it "should destroy an article" do
        @article.should_receive(:destroy)
        delete 'destroy', :id => 2
      end

      it "should redirect to the articles index" do
        delete 'destroy', :id => 2
        response.code.should == "302"
        response.should redirect_to(articles_path)
      end
    end

    context "user cannot delete articles" do
      before(:each) do
        @ability.cannot :destroy, Article
        delete 'destroy', :id => 2
      end

      it "should redirect to the homepage" do
        response.should redirect_to(root_path)
      end

      it "should set a flash warning" do
        request.flash[:alert].should == "You are not authorized to access this page."
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @article = mock_article(:id => 2)
    end

    it "should return the relevant article and build a new comment" do
      new_comment = mock_comment :save => false
      comments = [ mock_comment(:article_id => 2) ]

      Article.should_receive(:find).with(2) { @article }
      Comment.should_receive(:new).with({:article_id => 2}) { new_comment }
      @article.should_receive(:comments) { comments }
    end

    after(:each) do
      get 'show', :id => 2
    end
  end

  describe "GET 'new'" do
    before(:each) do
      stub_current_ability
      @article = mock_article
      Article.stub!(:new) { @article }
    end

    context "user can build a new article" do
      before(:each) do
        @ability.can :build, Article
      end

      it "should build a new article" do
        Article.should_receive(:new)
        get 'new'
      end
    end

    context "user cannot build a new article" do
      before(:each) do
        @ability.cannot :build, Article
        get "new"
      end

      it "should redirect to the homepage" do
        response.should redirect_to(root_path)
      end

      it "should set a flash alert" do
        request.flash[:alert].should == "You are not authorized to access this page."
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @article = mock_article :id => 2
    end

    it "should get the article" do
      Article.should_receive(:find).with(2) { @article }
    end

    after(:each) do
      get 'edit', :id => 2
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @article = mock_article
      @attrs = { "weasel" => "pox", "hen" => "scatter" }
      Article.stub!(:find) { @article }
      stub_current_ability
    end

    it "should fetch the article" do
      Article.should_receive(:find).with(2) { @article }
      put 'update', :id => 2
    end

    context "user is not authorized" do
      before(:each) do
        @ability.cannot :edit, Article
        put 'update', :id => 2
      end

      it "should redirect to the homepage" do
        response.should redirect_to(root_path)
      end

      it "should set a flash alert" do
        request.flash[:alert].should == "You are not authorized to access this page."
      end
    end

    context "user is authorized" do
      before(:each) do
        @ability.can :edit, Article
      end

      it "should update the article with the given attributes" do
        @article.should_receive(:update_attributes).with(@attrs)
        put 'update', :id => 2, :article => @attrs
      end

      context "article is valid after update" do
        it "should redirect to show article page" do
          @article.stub!(:valid?) { true }
          put 'update', :id => 2, :article => @attrs      
          response.should redirect_to(article_path(@article))
        end
      end

      context "article is invalid after update" do
        it "should render the new article template" do
          @article.stub!(:valid?) { false }
          put 'update', :id => 2, :article => @attrs      
          response.should render_template("new")
        end
      end
    end
  end

  describe "POST 'create'" do
    context "success" do
      before(:each) do
        @article = mock_article @attributes
      end

      it "should create a new article" do
        Article.should_receive(:create).with(@attributes) { @article }
        post :create, :article => @attributes
      end

      it "should redirect to the articles path" do
        post :create, :article => @attributes
        response.code.should == "302"
        response.should redirect_to(articles_path)
      end
    end

    context "failure" do
      before(:each) do
        @article = mock_article :title => ""
      end

      it "should create a new article" do
        Article.should_receive(:create).with({}) { @article }
        post :create, :article => {}
      end

      it "should not redirect" do
        post :create, :article => {}
        response.should_not redirect_to(articles_path)
        response.code.should == "200"
      end
    end
  end

  def mock_article(stubs={})
    (@mock_article ||= mock_model(Article).as_null_object).tap do |article|
      article.stub(stubs) unless stubs.empty?
    end
  end

  def mock_comment(stubs={})
    (@mock_comment ||= mock_model(Comment).as_null_object).tap do |comment|
      comment.stub(stubs) unless stubs.empty?
    end
  end

  def stub_current_ability
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stub!(:current_ability) { @ability }
  end
end
