# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    first_name "MyString"
    last_name "MyString"
    birthdate "MyString"
    phone "MyString"
    suit "MyString"
    address "MyString"
    city "MyString"
    country "MyString"
    postal "MyString"
  end
end
