FactoryBot.define do
  sequence :article_slug do |n|
    "sample-#{n}-content-slug"
  end
  
  factory :article do
    title { "Sample article" }
    content { "sample content" }
    slug { generate(:article_slug) }
  end
end
