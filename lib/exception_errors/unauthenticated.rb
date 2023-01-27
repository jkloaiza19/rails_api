class ExceptionErrors::Unauthenticated < StandardError
    attr_reader :detail, :status, :code, :title
    
    HTTP_STATUS_CODE = 401
    
    def initialize(opts = {})
        @status = HTTP_STATUS_CODE
        @title = opts.title || 'Unauthenticated'
        @detail = opts.detail || 'Unauthenticated'
        @code = opts.code || 'unauthenticated_user'
    end
end