module Service
  class FreeJob::Show < BaseOperation
    step Model(FreeJob, :find_by)
    step Policy::Pundit(FreeJob::Policy, :show?)
    failure :not_authorized!
  end
end
