# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :headline do
    string ""
    user_id 1
    published ""
    image "MyString"
  end
end
