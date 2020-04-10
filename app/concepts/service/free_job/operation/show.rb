module Service
  class FreeJob::Show < BaseOperation
    step Model(FreeJob, :find_by)
    step Policy::Pundit(FreeJobPolicy, :show?)
    failure :not_authorized!
  end
end
