FactoryBot.define do
  factory :comment do
    user_id { 1 }
    content { "美味しい" }
    association :dish
  end
end
