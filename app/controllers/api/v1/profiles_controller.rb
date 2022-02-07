module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      def me
        render json: current_resource_owner
      end

      def all
        render json: User.where.not(id: current_resource_owner.id), each_serializer: ProfileSerializer
      end
    end
  end
end
