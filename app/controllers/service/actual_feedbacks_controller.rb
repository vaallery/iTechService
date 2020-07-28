module Service
  class ActualFeedbacksController < ApplicationController
    skip_after_action :verify_authorized, only: :index
    respond_to :js

    def index
      feedbacks = policy_scope(Feedback).actual.includes(:service_job)
      @feedbacks_list = cell(Feedback::Cell::List, feedbacks).call
    end
  end
end
