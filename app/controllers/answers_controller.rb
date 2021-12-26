# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :find_question, only: %i[create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = t('.success')
    else
      flash[:notice] = t('.destroy.error.other')
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end
end
