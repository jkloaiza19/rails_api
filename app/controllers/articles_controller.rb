class ArticlesController < ApplicationController
    include Pagination
    before_action :autorized_user?
    
    after_action { pagy_headers_merge(@pagy) if @pagy }
     
    def index
        articles = Article.recent
        
        records, options = paginate(articles)
        
        render json: serializer.new(records, options), status: :ok
    end
    
    def show
        article = Article.find_by_id(article_params[:id].to_i)
        
        raise ActiveRecord::RecordNotFound unless article
        
        render json: serializer.new(article), status: :ok
    end
    
    def article_params
        params.permit(:id)
    end
    
    def serializer
        ArticleSerializer
    end
end
