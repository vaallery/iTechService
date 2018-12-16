module ReportsHelper

  def report_title(report)
    t("reports.#{report.is_a?(String) ? report : report.name}.title")
  end

  def report_names
    %w[device_types device_groups users devices_archived devices_not_archived done_tasks tasks_undone clients tasks_duration device_orders done_orders devices_movements payments salary driver few_remnants_goods few_remnants_spare_parts repair_jobs technicians_jobs technicians_difficult_jobs remnants sales margin quick_orders free_jobs phone_substitutions sms_notifications]
  end

  def report_default_params(report_name)
    {
      few_remnants_goods: {base_name: 'few_remnants', kind: 'goods'},
      few_remnants_spare_parts: {base_name: 'few_remnants', kind: 'spare_parts'}
    }.fetch report_name.to_sym, {base_name: report_name}
  end

  def remnants_row(data)
    row_class = data[:type]
    row_class << ' detailable' if data[:details].any?
    row_class << ' details' if data[:depth] > 0
    content = ''
    if data[:quantity] > 0
      content << content_tag(:tr, class: row_class, data: {depth: data[:depth], id: data[:id]}) do
        content_tag(:td, data[:code], class: 'code') +
        content_tag(:td, data[:name], class: 'name') +
        content_tag(:td, data[:quantity], class: 'quantity number') +
        content_tag(:td, human_currency(data[:purchase_price], false), class: 'price number') +
        content_tag(:td, human_currency(data[:price], false), class: 'price number') +
        content_tag(:td, human_currency(data[:sum], false), class: 'sum number')
      end.html_safe
    end
    content << data[:details].collect do |detail|
      remnants_row detail
    end.join
    content.html_safe
  end

end