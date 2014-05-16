# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart_product do
    cart nil
    product nil
    quantity 1
  end
end
