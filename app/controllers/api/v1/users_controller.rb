module Api
  module V1

    class UsersController < Api::BaseController
      #load_and_authorize_resource

      def profile
        if @current_user.present?
          respond_with @current_user
        else
          render status: 403, json: {error: t('')}
        end
      end

    end

  end
end
