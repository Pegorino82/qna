# frozen_string_literal: true

class NotificationJob < ApplicationJob
  queue_as :default

  def perform(object)
    Services::Notification.new.send_notification(object)
  end
end
