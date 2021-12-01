FactoryBot.define do
  factory :list do
    association :user
    association :dish
  end
end
