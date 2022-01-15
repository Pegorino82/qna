# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[like dislike]
    before_action :find_vote, only: %i[like dislike]
  end

  def like
    if @vote.nil?
      create_vote(1)
    else
      existed_vote('like')
    end
  end

  def dislike
    if @vote.nil?
      create_vote(-1)
    else
      existed_vote('dislike')
    end
  end

  private

  def create_vote(value)
    @vote = @votable.votes.build(author: current_user, value: value)
    if @vote.save
      # render_html
      render_json
    else
      render_errors
    end
  end

  def existed_vote(action)
    if current_user.author_of?(@votable)
      @vote.author_validation
    else
      @vote.send(action)
    end

    # render_html
    render_json
  end

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def find_vote
    @vote = @votable.votes.find_by(author: current_user)
  end

  def render_html
    respond_to do |format|
      format.html { render partial: 'votes/vote', locals: { resource: @votable } }
    end
  end

  def render_json
    respond_to do |format|
      format.json do
        render json: {
          vote_value: @vote.value,
          votable_id: @votable.id,
          votable_class: @votable.class.name.underscore,
          vote_count: @votable.vote_count
        }
      end
    end
  end

  def render_errors
    respond_to do |format|
      format.html do
        render partial: 'shared/errors',
               locals: { resource: @votable },
               status: :unprocessable_entity
      end

      format.json { render json: @votable.errors.full_messages, status: :unprocessable_entity }
    end
  end
end
