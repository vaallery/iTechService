module Service
  class ActualFeedbacksController < ApplicationController
    skip_after_action :verify_authorized, only: :index

    def index
      respond_to do |format|
        run Feedback::IndexActual do
          format.js { return render(locals: {feedbacks_list: feedbacks_list}) }
        end
        format.js { failed }
      end
    end

    private

    def feedbacks_list
      cell(Feedback::Cell::List, @model).call
    end
  end
end
