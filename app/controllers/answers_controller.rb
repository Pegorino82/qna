# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :find_question, only: %i[create]

  def new; end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to @question, notice: t('answers.create.success')
    else
      render :new
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    question = @answer.question
    if current_user.author_of?(question)
      @answer.destroy
      flash[:notice] = t('.success')
    else
      flash[:notice] = t('.destroy.error.other')
    end
    redirect_to question
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end
end
