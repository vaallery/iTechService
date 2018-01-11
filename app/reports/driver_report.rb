class DriverReport < BaseReport

  def call
    result[:supply_categories] = []
    supply_reports = SupplyReport.where date: period
    supplies_sum = 0
    if supply_reports.present?
      if (supplies = Supply.where supply_report_id: supply_reports.map(&:id)).any?
        supplies.group(:supply_category_id).sum('id').each_pair do |key, val|
          if key.present? and (supply_category = SupplyCategory.find(key)).present?
            category_supplies = supplies.where(supply_category_id: key)
            category_sum = category_supplies.map{|s|s.sum}.sum
            result[:supply_categories] << {name: supply_category.name, sum: category_sum, supplies: category_supplies}
            supplies_sum = supplies_sum + category_sum
          end
        end
      end
    end
    result[:supplies_sum] = supplies_sum
    result
  end
end