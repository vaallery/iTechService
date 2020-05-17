class DevicesArchivedReport < BaseReport
  def call
    result[:users_mv] = []
    movements = HistoryRecord.movements_to_archive(department).in_period(period)
    total_qty = 0
    if movements.any?
      movements.group('user_id').count('id').each_pair do |user_id, qty|
        user_name = (user = User.find_by(id: user_id)) ? user.short_name : '?'

        jobs = []
        movements.where(user_id: user_id).find_each do |movement|
          job = movement.object
          jobs << {id: job.id, ticket: job.ticket_number, device: job.type_name}
        end

        result[:users_mv] << {user: user_name, qty: qty, jobs: jobs}
        total_qty += qty
      end
    end
    result[:total_qty] = total_qty
    result
  end
end