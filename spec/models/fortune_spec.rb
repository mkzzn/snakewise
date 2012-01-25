require 'spec_helper'

describe Fortune do
  context "validations" do
    context "attributes" do
      before(:each) do
        @fortune = Factory.build :fortune, :fortune => "" 
        @fortune.save
      end

      it "should validate presence of fortune" do
        @fortune.should_not be_valid
      end
    end
  end

  context "scopes" do
    before(:all) do
      Fortune.destroy_all
    end

    describe "published" do
      it "should return published fortunes" do
        @fortune = Factory :fortune, :published => true
        Fortune.published.should include(@fortune)
      end

      it "should not return unpublished fortunes" do
        @fortune = Factory :fortune, :published => false
        Fortune.published.should_not include(@fortune)
      end
    end
  end

  context "associations" do
    context "comments" do
      before(:each) do
        @fortune = Factory :fortune
        @comment = Factory :comment, :fortune => @fortune
      end

      it "should have comments" do
        @fortune.comments.first.should == @comment
      end

      it "should destroy dependent comments on deletion" do
        @fortune.destroy
        Comment.count(@comment[:id]).should == 0
      end
    end
  end

  describe "created_date" do
    context "fortune has a created_at timestamp" do
      it "should return a formatted YYYY-MM-DD timestamp" do
        fortune = Factory :fortune, :created_at => Date.parse("2011-10-02")
        fortune.created_date.should == "2011-10-02"
      end
    end

    context "fortune has not been created" do
      it "should be nil" do
        Factory.build(:fortune).created_at.should be_nil
      end
    end
  end

  describe "author name" do
    before(:each) do
      @fortune = Factory :fortune
    end

    context "fortune has a user" do
      it "should return the full name of the user" do
        user = Factory :user
        user.stub! :full_name => "Greg Anderson"
        @fortune.update_attributes :user => user
        @fortune.author_name.should == "Greg Anderson"
      end
    end

    context "fortune has no user" do
      it "should return nil" do
        @fortune.author_name.should be_nil
      end
    end
  end

  describe "published_state" do
    context "fortune is not published" do
      it "should be 'Unpublished'" do
        fortune = Factory :fortune, :published => false
        fortune.published_state.should == "Unpublished"
      end
    end

    context "fortune is published" do
      it "should be 'Published'" do
        fortune = Factory :fortune, :published => true
        fortune.published_state.should == "Published"
      end
    end
  end
end
