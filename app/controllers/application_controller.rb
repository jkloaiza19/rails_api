class ApplicationController < ActionController::API
    include Pagy::Backend
    # before_action :authenticate_user!
    
    def render_json_error(error)
        render json: { errors: [error] }, status: error.status
    end

    # It checks if the Authorization header is present and if it is, it returns the token
    def header_auth_token
        (request.headers['Authorization'] =~ /^Bearer\s./).present? ? request.headers['Authorization'].split(' ').last : nil
    end

    # > It gets the access token from the header, and then verifies it using the Firebase Authenticator
    def autorized_user?
        token = header_auth_token
        
        raise ExceptionErrors::InvalidToken.new(detail: 'Authorization header not found') unless token

        Firebase::AuthenticationManager.valid_token?(token)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
        render_json_error ExceptionErrors::NotFound.new(detail: e.message)
    end

    rescue_from ExceptionErrors::InvalidToken do |e|
        render_json_error e
    end
end
