# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy best_answer]

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
    params.require(:answer).permit(:body, :correct, files: [], links_attributes: [:title, :url])
  end
end
