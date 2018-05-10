module Service
  class FreeTask::Index < BaseOperation
    step Policy::Pundit(FreeTask::Policy, :index?)
    failure :not_authorized!
    step :model!

    private

    def model!(options, **)
      options['model'] = FreeTask.order(:name)
    end
  end
end
