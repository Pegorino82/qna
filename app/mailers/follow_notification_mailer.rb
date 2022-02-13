# frozen_string_literal: true

class FollowNotificationMailer < ApplicationMailer
  def send_notification(object)
    @question = object
    mail(to: current_user.email,
         subject: "There are a new answer in '#{@question.title}' question")
  end
end
