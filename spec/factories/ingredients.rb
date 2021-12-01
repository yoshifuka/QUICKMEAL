FactoryBot.define do
  factory :ingredient do
    name { "麺" }
    quantity { "300g" }
    association :dish
  end
end
