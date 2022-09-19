require 'rails_helper'

RSpec.describe ArticlesController do
  describe "GET /index" do
    it "Returns a success response" do
      get "/articles"
      
      # expect(response.status).to eq(200)
      expect(response).to have_http_status(:ok)
    end
    
    it "Returns a proper json" do
      article = create :article
      pp article
      
      get '/articles'
      
      expect(json_data.length).to eq(1)
      
      response = json_data.first
      
      aggregate_failures do
      expect(response[:type]).to eq('article')
      expect(response[:id]).to eq(article.id.to_s)
      expect(response[:attributes]).to eq(
          title: article.title,
          content: article.content,
          slug: article.slug
        )
      end
    end
    
    it 'returns articles in the proper order' do
        older_article =
        create(:article, created_at: 1.hour.ago)
            
        recent_article = create(:article)
        
        get '/articles'
        
        ids = json_data.map { |article| article[:id].to_i }
        
        expect(ids).to eq(
          [recent_article[:id], older_article[:id]]
        )
    end
    
    it 'paginates results' do
      article1, article2, article3 = create_list(:article, 3)
      
      get '/articles', params: { page: 2, size: 1 }
      
      expect(json_data.length).to eq(1)
      expect(json_data.first[:id]).to eq(article2[:id].to_s)
      
    end
    
    it 'contains pagination links in the response' do
      article1, article2, article3 = create_list(:article, 3)
      
      get '/articles', params: { page: 2, size: 1 }

      expect(json[:links].length).to eq(5)
      expect(json[:links].keys).to contain_exactly(
        :first, :prev, :current, :next, :last
      )
      
    end
  end
  
  describe '#show' do
    let(:article) { create :article }
    
    subject { get '/articles', params: { id: article[:id] } }
    
    before { subject }
    
    it 'Returns http status ok' do
      expect(response).to have_http_status(:ok)
    end
    
    it 'Returns a single article by id' do
      pp json_data
      
      expect(json_data.first[:id]).to eq(article[:id].to_s)
      expect(json_data.first[:type]).to eq('article')
      expect(json_data.first[:attributes]).to eq(
        title: article.title,
        content: article.content,
        slug: article.slug
        )
    end
  end
end
