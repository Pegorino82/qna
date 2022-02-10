# frozen_string_literal: true

module Services
  class Notification
    def send_notification(answer)
      FollowNotificationMailer.send_notification(answer).deliver_later
    end
  end
end
