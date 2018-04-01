# frozen_string_literal: true

FactoryBot.define do
  factory :placement do
    order
    product
    quantity 1
  end
end
