class ApplicationController < ActionController::API
    include Pagy::Backend
    
    rescue_from ActiveRecord::RecordNotFound do |e|
        render_json_error ExceptionErrors::NotFound.new(detail: e.message)
    end
    
    def render_json_error(error)
        render json: { errors: [error] }, status: error.status
    end
end
