# frozen_string_literal: true

class Question < ApplicationRecord
  include Attachable
  include Linkable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_one :award, dependent: :destroy

  accepts_nested_attributes_for :award, reject_if: :all_blank

  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true

  scope :new_on_top, -> { order(created_at: :desc) }

  def answers_without_best
    answers.where.not(id: best_answer_id)
  end
end
