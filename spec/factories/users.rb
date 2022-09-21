FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@test.com" }
    email { 'foo@test.com' }
    password { "foo123" }
  end
end
