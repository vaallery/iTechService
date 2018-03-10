module Service
  class Feedback::Postpone < BaseOperation
    step Model(Feedback, :find_by)
    failure :record_not_found!
    step Policy.Pundit(Feedback::Policy, :update?)
    failure :not_authorized!
    step :postpone!

    private

    def postpone!(model:, **)
      if model.postpone_count < 5
        model.scheduled_on = 1.hour.from_now
        model.postpone_count += 1
      else
        model.scheduled_on = 1.day.from_now.change(hour: 10)
        model.postpone_count = 0
      end

      model.save
    end
  end
end
