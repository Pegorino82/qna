# frozen_string_literal: true

class Question < ApplicationRecord
  include Attachable
  include Linkable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_one :award, dependent: :destroy
  has_many :followings, dependent: :destroy

  accepts_nested_attributes_for :award, reject_if: :all_blank

  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :author, class_name: 'User'

  validates :title, :body, presence: true

  scope :new_on_top, -> { order(created_at: :desc) }

  after_create :calculate_reputation
  after_create :follow

  def answers_without_best
    answers.where.not(id: best_answer_id)
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def follow
    self.followings.create(author_id: self.author_id)
  end
end
