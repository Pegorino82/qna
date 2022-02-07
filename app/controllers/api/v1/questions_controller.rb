module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      before_action :find_question, only: %i[show answers update destroy]
      before_action :current_user, only: %i[create update destroy]

      def index
        render json: Question.all, each_serializer: QuestionsSerializer
      end

      def show
        render json: @question, serializer: QuestionSerializer
      end

      def answers
        render json: @question.answers, each_serializer: AnswersSerializer
      end

      def create
        authorize Question
        @question = @current_user.questions.build(question_params)

        if @question.save
          render json: @question, serializer: QuestionSerializer
        else
          render json: @question.errors.messages
        end
      end

      def update
        authorize @question, :api_update?, policy_class: QuestionPolicy
        if @question.update(question_params)
          render json: @question, serializer: QuestionSerializer
        else
          render json: @question.errors.messages
        end
      end

      def destroy
        authorize @question, :api_destroy?, policy_class: QuestionPolicy
        if @question.destroy
          render json: { status: :ok }
        else
          render json: @question.errors.messages
        end
      end

      private

      def find_question
        @question = Question.find(params[:id])
      end

      def current_user
        @current_user = current_resource_owner
      end

      def question_params
        params.require(:question).permit(:title, :body, links_attributes: %i[title url])
      end
    end
  end
end
