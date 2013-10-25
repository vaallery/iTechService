module Api
  module V1

    class UsersController < Api::BaseController
      load_and_authorize_resource

      def profile
        @user = current_user

        respond_with @user
      end

    end

  end
end