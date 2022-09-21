FactoryBot.define do
  factory :jwt_blacklist do
    jti { "MyString" }
    exp { "2022-09-19 19:28:33" }
  end
end
