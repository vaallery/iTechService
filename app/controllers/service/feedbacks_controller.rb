module Service
  class FeedbacksController < ApplicationController
    skip_after_action :verify_authorized

    def edit
      @model = find_record(Feedback)
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
