# frozen_string_literal: true

module Services
  class Notification
    def send_notification(object)
      FollowNotificationMailer.send_notification(object).deliver_later
    end
  end
end
