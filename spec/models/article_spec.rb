require 'rails_helper'

RSpec.describe Article, type: :model do
    describe "#validations" do
        let(:article) { build(:article) }
        
         it "test that factory is valid" do
            expect(article).to be_valid
        end
    
        it "has an invalid article title" do
            article.title = ''
            
            expect(article).not_to be_valid
        end
    end
    
    describe ".recent" do
        it "returns the data in descent format" do
             older_article =
            create(:article, created_at: 1.hour.ago)
            
            recent_article = create(:article)
            
            expect(described_class.recent).to eq(
                    [recent_article, older_article]
                )
                
            recent_article.update_column(:created_at, 2.hours.ago)
            
            expect(described_class.recent).to eq(
                    [older_article, recent_article]
                )
        end
    end
end
# rspec spec/models/article_spec.rb --format=documentation
