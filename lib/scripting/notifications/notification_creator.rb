module Notifications
  # It finds all users with a user_id in the user_emails array, and then sends a notification to each
  # user
  class NotificationCreator < BaseService
    def call
      process_notifications
    end

    def process_notifications
      User.where(user_id: user_emails).find_in_batches(batch_size: 100) do |group|
        sleep(10)
        group.each { |user| send_notification(user) }
      end
    end

    def send_notification(user)
      puts user
    rescue StandardError => e
      puts e.class
    end
  end
end
