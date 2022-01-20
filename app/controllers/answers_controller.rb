# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: :create
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy best_answer]

  after_action :publish_answer, only: %i[create update]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = t('.success')
    else
      flash.now[:notice] = t('.destroy.error.other')
    end
  end

  def best_answer
    @answer.mark_as_best if current_user.author_of?(@answer.question)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct, files: [], links_attributes: %i[title url])
  end

  def publish_answer
    return if @answer.errors.any?

    gon.push({
               answer_owner: @answer.author.id,
               question_owner: @question.author.id
             })

    ActionCable.server.broadcast("question_#{@answer.question.id}_answers", @answer.as_json)
    # ActionCable.server.broadcast(
    #   "question_#{@answer.question.id}_answers",
    #   ApplicationController.render(
    #     partial: 'answers/answer',
    #     locals: { answer: @answer, answer_class: '' }
    #   )
    # )
  end
end
