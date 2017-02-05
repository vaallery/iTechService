class DevicesArchivedReport < BaseReport

  def call
    result[:users_mv] = []
    movements = HistoryRecord.in_period(period)
    movements = movements.movements_from(Location.bar.id)
    movements = movements.movements_to([Location.content.id, Location.repair.id])
    total_qty = 0
    if movements.any?
      movements.group('user_id').count('id').each_pair do |key, val|
        if key.present? and (user = User.find key).present?
          result[:users_mv] << {user: user.short_name, qty: val}
        else
          result[:users_mv] << {user: '?', qty: val}
        end
        total_qty += val
      end
    end
    result[:total_qty] = total_qty
    result
  end
end