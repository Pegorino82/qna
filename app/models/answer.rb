# frozen_string_literal: true

class Answer < ApplicationRecord
  include Attachable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many :links, dependent: :destroy, as: :linkable
  has_one :award

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  def best?
    id == question.best_answer_id
  end

  def mark_as_best
    question.update(best_answer: self)
    question.award&.update(answer: self)
  end
end
