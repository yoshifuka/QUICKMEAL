FactoryBot.define do
  factory :record do
    content { "砂糖多めに" }
    association :dish
  end
end
