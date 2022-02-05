# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: :create
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy best_answer]

  after_action :publish_answer, only: %i[create]

  def create
    authorize Answer
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    authorize @answer
    @answer.update(answer_params)
  end

  def destroy
    authorize @answer
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = t('.success')
    else
      flash.now[:notice] = t('.destroy.error.other')
    end
  end

  def best_answer
    authorize @answer
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

    ActionCable.server.broadcast(
      "question_#{@answer.question.id}_answers",
      {
        answer: @answer.as_json,
        files: files,
        links: links,
        author: @answer.author.as_json,
        vote_count: @answer.vote_count,
      }.as_json)
  end

  def files
    @answer.files.map do |file|
      {
        id: file.id,
        path: url_for(file),
        name: file.filename
      }
    end.as_json
  end

  def links
    @answer.links.map do |link|
      {
        id: link.id,
        path: url_for(link.url),
        name: link.title
      }
    end.as_json
  end
end
