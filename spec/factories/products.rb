# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    title { FFaker::Product.product_name }
    price { rand * 100 }
    published { FFaker::Boolean.maybe }
    quantity { rand }
    user
  end
end
