module ReportsHelper

  def reports_collection_for_select
    reports = can?(:manage, Salary) ? Report::NAMES : Report::NAMES - ['salary']
    reports.collect { |report| [report_title(report), report] }
  end

  def report_title(report)
    t("reports.#{report.is_a?(Report) ? report.name : report}.title")
  end

end