module Notifications
  # It's a base class that can be inherited by other classes to provide a common interface for calling
  # a service
  class BaseService
    attr_reader :user_emails

    def self.call(args)
      new(args).call
    end

    def initialize(args)
      @user_emails = args.user_emails
    end

    # To be implemented by the child class
    def call; end
  end
end
