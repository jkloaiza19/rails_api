# > This class is used to create a JSON API compliant error response when a resource is not found
class ExceptionErrors::NotFound < StandardError
    attr_reader :detail, :status, :code, :title
    
    HTTP_STATUS_CODE = 404  
    
    def initialize(opts = {})
        @status = HTTP_STATUS_CODE
        @title = opts[:title] || 'Not found'
        @detail = opts[:detail] || 'Not found'
        @code = opts[:code] || 'resource_not_found'
    end
end