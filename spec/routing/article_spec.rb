require 'rails_helper'

RSpec.describe 'Articles routing' do
    describe 'articles#index' do
        it "routes to articles#index" do
            expect(get '/articles').to route_to('articles#index')
            # expect(get '/articles').to route_to(
            #     controller: 'articles',
            #     action: 'show',
            #     id: '1'
            # )
            #expect(get '/articles/page[number]=3').to route_to('articles#index', page: { numeber: 3 })
        end
    end
end
# rspec spec/routing/article_spec.rb --format=documentation