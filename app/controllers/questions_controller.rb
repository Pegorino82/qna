# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit update destroy]

  after_action :publish_question, only: %i[create]

  def index
    authorize Question
    @questions = Question.new_on_top.all
  end

  def show
    authorize @question
    @following = Following.find_by(author: current_user, question: @question)
    @answer = @question.answers.build
    @answer.links.build
  end

  def new
    authorize Question
    @question = Question.new
    @question.links.build
    @award = Award.new(question: @question)
  end

  def edit; end

  def create
    authorize Question
    @question = current_user.questions.build(question_params)

    if @question.save
      @question.followings.create(author: current_user)
      redirect_to @question, notice: t('.success')
    else
      render :new
    end
  end

  def update
    authorize @question
    @question.update(question_params)
  end

  def destroy
    authorize @question
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path
    else
      redirect_to @question, notice: t('.destroy.errors.other')
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
    gon.push({
               current_user_id: current_user&.id,
               question_id: @question.id
             })
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: %i[title url],
                                     award_attributes: %i[title image])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
