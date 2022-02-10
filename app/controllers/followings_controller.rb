# frozen_string_literal: true

class FollowingsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :find_following, only: %i[destroy]

  def create
    authorize Following
    @following = current_user.followings.build(following_params)
    @following.save
  end

  def destroy
    authorize @following
    @question = @following.question
    @following.destroy!
  end

  private

  def find_following
    @following = Following.find(params[:id])
  end

  def following_params
    params.permit(:question_id)
  end
end
