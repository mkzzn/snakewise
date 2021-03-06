Given /^confirmed user with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  attrs = Factory.attributes_for(:user, :password => password, :password_confirmation => password)
  user = User.find_or_create_by_email(email, attrs)
  user.confirm!
end

Given /^I sign in with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "user_submit"
end

Then /^I should see that I am not signed in$/ do
  page.should have_xpath("//div[@id='session']//a[@class='title'][contains(.,'Sign In')]")
end

Then /^I should see that I am signed in as user "([^"]*)"$/ do |email|
  page.should have_xpath("//div[@id='session']//a[@class='title'][contains(.,'#{email}')]")
end

Then /^I should see a notice saying that I was signed in successfully$/ do
  page.should have_xpath("//div[contains(@class,'notice')][contains(.,'Signed in successfully')]")
end

Then /^I should see an alert saying that I was not signed in$/ do
  page.should have_xpath("//div[contains(@class,'alert')][contains(.,'Invalid email or password')]")
end

Given /^unconfirmed user with email "([^"]*)" and password "([^"]*)"$/ do |email, password|
  attrs = Factory.attributes_for(:user, :password => password, :password_confirmation => password)
  User.find_or_create_by_email(email, attrs)
end

Then /^I should see an alert saying that my account is not confirmed$/ do
  page.should have_xpath("//div[contains(@class,'alert')][contains(.,'You have to confirm your account before continuing')]")
end
