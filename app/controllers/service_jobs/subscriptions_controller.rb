module ServiceJobs
  class SubscriptionsController < ApplicationController
    skip_after_action :verify_authorized

    def create
      @service_job = find_service_job
      @service_job.subscribers.push(current_user)
      respond_to do |format|
        format.js { render :refresh }
      end
    end

    def destroy
      @service_job = find_service_job
      @service_job.subscribers.delete(current_user)
      respond_to do |format|
        format.js { render :refresh }
      end
    end

    private

    def find_service_job
      policy_scope(ServiceJob).find(params[:service_job_id])
    end
  end
end