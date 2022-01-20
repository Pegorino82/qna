class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    Rails.logger.info data
    Rails.logger.info "question_#{data['question_id']}_answers"
    stream_from "question_#{data['question_id']}_answers"
  end
end
