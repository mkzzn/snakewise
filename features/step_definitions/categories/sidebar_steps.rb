Given /^category "([^"]*)" has (\d+) other articles$/ do |category, articles|
  category = Category.find_by_title category
  articles.to_i.times { Factory :article, :category => category }
end

Then /^I should see category "([^"]*)" in the sidebar$/ do |category|
  page.should have_xpath("//ul[@class='categories']//li//a[contains(.,'#{category}')]")
end

Then /^category "([^"]*)" should show that it has (\d+) articles$/ do |category, article_count|
  page.should have_xpath("//ul[@class='categories']//li//a[contains(.,'#{category}')][contains(.,'(#{article_count})')]")
end

When /^I click category "([^"]*)" in the sidebar$/ do |category|
 find(:xpath, "//ul[@class='categories']//li//a[contains(.,'#{category}')]").click
end
