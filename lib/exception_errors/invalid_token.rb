module ExceptionErrors
# Creating a new class called InvalidToken.
  class InvalidToken < StandardError
    attr_reader :detail, :status, :code, :title

    HTTP_STATUS_CODE = 403

    def initialize(opts = {})
      @status = HTTP_STATUS_CODE
      @title = opts[:title] || 'Not found'
      @detail = opts[:detail] || 'Not found'
      @code = opts[:code] || 'resource_not_found'

      super(@detail)
    end
  end
end
