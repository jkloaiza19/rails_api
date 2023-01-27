FactoryBot.define do
  factory :post do
    caption { "MyString" }
    latitude { 1.5 }
    longitude { 1.5 }
    user { nil }
    allow_comments { false }
    show_likes_count { false }
  end
end
