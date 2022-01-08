# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :award, dependent: :destroy

  has_many_attached :files
  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true

  def answers_without_best
    answers.where.not(id: best_answer_id)
  end
end
