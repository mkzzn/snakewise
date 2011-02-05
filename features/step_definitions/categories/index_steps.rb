Given /^category "([^"]*)" with description "([^"]*)"$/ do |title, desc|
  Factory :category, :title => title, :description => desc
end

Given /^category "([^"]*)" has an article entitled "([^"]*)"$/ do |category, article|
  category = Category.find_by_title category
  Factory :article, :title => article, :category => category
end

Then /^I should see article "([^"]*)" within category "([^"]*)"$/ do |article, category|
  category = Category.find_by_title category
  page.should have_xpath("//div[@id='category_#{category[:id]}']//div[@class='article']//a[@class='title'][contains(.,'#{article}')]")
end

Then /^I should not see article "([^"]*)" within category "([^"]*)"$/ do |article, category|
  page.should_not have_xpath("//div[@class='category']//div[@class='article']//div[@class='title'][contains(.,'#{article}')]")
end

When /^I click to visit article "([^"]*)"$/ do |article|
  click_link article
end

Then /^I should be viewing the article entitled "([^"]*)"$/ do |article|
  article = Article.find_by_title article
  current_path.should == article_path(article)
end

Given /^article "([^"]*)" is the (.*) article in category "([^"]*)"$/ do |article, number, category|
  order = {"third" => 2, "fourth" => 3}
  @category = Category.find_by_title category
  (order[number] - @category.articles.count).times do
    Factory :article, :category => @category
  end
  Factory :article, :category => @category, :title => article
end

Given /^I am viewing the homepage$/ do
  visit articles_path
end

Given /^I click the categories navigation heading$/ do
  find(:xpath, "//div[@class='navigation primary']//li[@class='title']//a[contains(@class, 'categories')]").click
end
