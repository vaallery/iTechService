module ReportsHelper

  def reports_collection_for_select
    reports = can?(:manage, Salary) ? Report::NAMES : Report::NAMES - ['salary']
    reports.collect { |report| [report_title(report), report] }
  end

  def report_title(report)
    t("reports.#{report.is_a?(Report) ? report.name : report}.title")
  end

  def remnants_row(data)
    row_class = data[:type]
    row_class << ' detailable' if data[:details].any?
    row_class << ' details' if data[:depth] > 0
    content = ''
    if data[:quantity] > 0
      content << content_tag(:tr, class: row_class, data: {depth: data[:depth], id: data[:id]}) do
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