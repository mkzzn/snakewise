class PagesController < ApplicationController
  def homepage
    @headlines = Headline.published.all
    @fortunes = Fortune.published.all
  end

  def writers
    @writers = User.with_published_articles.order "last_name asc"
  end
end
