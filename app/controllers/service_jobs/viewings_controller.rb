module ServiceJobs
  class ViewingsController < ApplicationController
    def index
      authorize ServiceJobViewing
      @service_job_viewings = policy_scope(ServiceJobViewing).where(service_job_id: params[:service_job_id]).new_first

      respond_to do |format|
        format.js { render 'shared/show_modal_form' }
      end
    end
  end
end
