FactoryGirl.define do
  factory :order do
    total { rand() * 100 }
    user
  end
end
