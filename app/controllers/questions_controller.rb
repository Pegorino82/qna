# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: t('.success')
    else
      render :new
    end
  end

  def update
    @question.update(question_params)

    if @question.save
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path
    else
      redirect_to @question, notice: t('.destroy.errors.other')
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
