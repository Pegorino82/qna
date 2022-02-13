# frozen_string_literal: true

class Answer < ApplicationRecord
  include Attachable
  include Linkable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_one :award

  validates :body, presence: true

  def best?
    id == question.best_answer_id
  end

  def mark_as_best
    question.update(best_answer: self)
    question.award&.update(answer: self)
  end

  private

  def follow_notification
    NotificationJob.perform_later(self.question)
  end
end
