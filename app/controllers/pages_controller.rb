class PagesController < ApplicationController
  def homepage
    if can? :manage, Fortune
      @fortunes = Fortune.order "created_at desc"
      @headlines = Headline.order "created_at desc"
    else 
      @fortunes = Fortune.published.order "created_at desc"
      @headlines = Headline.published.order "created_at desc"
    end
  end

  def writers
    @writers = User.with_published_articles.order "last_name asc"
  end
end
