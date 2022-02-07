# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      before_action :find_answer, only: %i[show update destroy]
      before_action :current_user, only: %i[create update destroy]

      def show
        render json: @answer, serializer: AnswerSerializer
      end

      def create
        authorize Answer
        @answer = Answer.new(answer_params)
        @answer.author = current_user

        if @answer.save
          render json: @answer, serializer: AnswerSerializer
        else
          render json: @answer.errors.messages
        end
      end

      def update
        authorize @answer, :api_update?, policy_class: AnswerPolicy
        if @answer.update(answer_params)
          render json: @answer, serializer: AnswerSerializer
        else
          render json: @answer.errors.messages
        end
      end

      def destroy
        authorize @answer, :api_destroy?, policy_class: AnswerPolicy
        if @answer.destroy
          render json: { status: :ok }
        else
          render json: @answer.errors.messages
        end
      end

      private

      def find_answer
        @answer = Answer.find(params[:id])
      end

      def current_user
        @current_user = current_resource_owner
      end

      def answer_params
        params.require(:answer).permit(:question_id, :body, links_attributes: %i[title url])
      end
    end
  end
end
