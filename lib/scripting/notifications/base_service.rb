module Notifications
  # It's a base class that can be inherited by other classes to provide a common interface for calling
  # a service
  class BaseService
    attr_reader :user_emails

    def self.call(args)
      new(args).call
    end

    def self.perform(*args)
      new(*args).perform
    end

    def initialize(user_emails, user_state)
      @user_emails = user_emails
      @user_state = user_state
    end

    # To be implemented by the child class
    def call; end

    def perform; end
  end
end
