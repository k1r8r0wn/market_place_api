FactoryGirl.define do
  factory :product do
    title { FFaker::Product.product_name }
    price { rand() * 100 }
    published false
    user
  end
end
