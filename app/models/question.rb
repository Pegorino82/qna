class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true

  def set_best_answer(answer_id)
    update(best_answer_id: answer_id)
  end

  def answers_without_best
    answers.where.not(id: best_answer_id)
  end
end
