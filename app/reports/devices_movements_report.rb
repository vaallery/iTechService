class DevicesMovementsReport < BaseReport

  def call
    result[:users_mv] = []
    movements = HistoryRecord.in_period(period)
    movements = movements.movements_from(Location.bar.id)
    movements = movements.movements_to([Location.content.id, Location.repair.id])
    if movements.any?
      movements.group('user_id').count('id').each_pair do |key, val|
        if key.present? and (user = User.find key).present?
          user_movements = movements.by_user(user)
          service_jobs = []
          user_durations = []
          user_movements.each do |movement|
            if (service_job = ServiceJob.find(movement.object_id)).present?
              old_location = Location.find movement.old_value.to_i
              new_location = Location.find movement.new_value.to_i
              duration = ((movement.created_at - service_job.created_at).to_i/60).round
              user_durations << duration
              service_jobs << {moved_at: movement.created_at, created_at: service_job.created_at, old_location: old_location.name, new_location: new_location.name, device_id: service_job.id, service_job_presentation: service_job.presentation, client_id: service_job.client_id, client_presentation: service_job.client_presentation, duration: duration}
            end
          end
          avarage_duration = (user_durations.sum / user_durations.size).round
          result[:users_mv] << {user: user.short_name, avarage_duration: avarage_duration, qty: val, service_jobs: service_jobs}
        end
      end
    end
    result
  end
end