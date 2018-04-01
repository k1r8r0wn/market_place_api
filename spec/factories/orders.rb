# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    total 0
    user
  end
end
