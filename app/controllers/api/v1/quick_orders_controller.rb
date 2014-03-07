module Api
  module V1
    class QuickTasksController < Api::BaseController
      authorize_resource

      def create
        @quick_order = QuickOrder.new(params[:quick_order])

        if @quick_order.save
          render status: :created, location: @quick_order
        else
          render json: @quick_order.errors, status: :unprocessable_entity
        end
      end

    end
  end
end