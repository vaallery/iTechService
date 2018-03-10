module Service
  class FeedbacksController < ApplicationController
    def edit
      @model = Feedback.find(params[:id])
      respond_to do |format|
        format.js
      end
    end

    def update
      respond_to do |format|
        run Feedback::Update do
          format.js { return }
        end
        format.js { failed }
      end
    end

    def postpone
      respond_to do |format|
        run Feedback::Postpone do
          format.js { return render(:update) }
        end
        format.js { failed }
      end
    end
  end
end
