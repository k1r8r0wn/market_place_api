# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    total { rand }
    user
  end
end
