module Service
  class FreeJob::Index < BaseOperation
    step Policy::Pundit(FreeJob::Policy, :index?)
    failure :not_authorized!
    step :model!

    private

    def model!(options, params:, **)
      jobs = FreeJob.includes(:performer)

      if params[:date].present?
        date = params[:date].to_date
        jobs = jobs.where(performed_at: date.beginning_of_day..date.end_of_day)
      end

      if params[:performer].present?
        performer = params[:performer].mb_chars.downcase.to_s
        jobs = jobs.where('LOWER(name) LIKE :p OR LOWER(surname) LIKE :p', p: performer).references(:users)
      end

      options['model'] = jobs.new_first.page(params[:page])
    end
  end
end
