FactoryBot.define do
  factory :dish do
    name { Faker::Food.dish }
    description { "冬に食べたくなる、身体が温まる料理です" }
    portion { 1 }
    tips { "ピリッと辛めに味付けするのがオススメ" }
    way_of_cooking { "切って煮る" }
    required_time { 30 }
    association :user
    created_at { Time.current }
  end
  trait :picture do
    picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test_dish1.jpg')) }
  end
end
