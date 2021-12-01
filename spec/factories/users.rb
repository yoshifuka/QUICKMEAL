FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    sequence(:email) { |n| "example#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    introduction { "はじめまして。料理頑張ります！" }
  end
end
