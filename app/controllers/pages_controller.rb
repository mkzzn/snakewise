class PagesController < ApplicationController
  def homepage
    @headlines = Article.where :category_id => 2
    @fortunes = Article.where :category_id => 3
  end

  def writers
    @writers = User.with_published_articles.order "last_name asc"
  end
end
