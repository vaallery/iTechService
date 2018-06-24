module TimesheetDaysHelper

  def timesheet_row(user, date, time, row_num)
    row_class = 'timesheet_row'
    row_class << ' error' if user.is_fired?
    content_tag(:tr, data: { user: user.id }, class: row_class) do

      content_tag(:td, row_num) +
      content_tag(:td, link_to(user.short_name, user_path(user), target: '_blank'), class: 'fio_col') +
      content_tag(:td, user.job_title, class: 'job_title_col') +
      (date..date.end_of_month).map { |cur_date| timesheet_cell(user, cur_date, time) }.join.html_safe +
      content_tag(:td, user.work_days_in(date), class: 'work_days_count') +
      content_tag(:td, user.work_hours_in(date).truncate, class: 'work_hours_count') +
      content_tag(:td, user.sickness_days_in(date), class: 'sickness_days_count') +
      content_tag(:td, user.latenesses_in(date), class: 'lateness_count')
    end
  end

  def timesheet_cell(user, date, time)
    cell_class = 'timesheet_day has-tooltip'
    if (timesheet_day = user.timesheet_day(date)).present?
      cell_class << " #{timesheet_day.status}"
      status_abbr = t "timesheet_days.statuses_abbr.#{timesheet_day.status}"
      value = timesheet_day.work_hours
      id = timesheet_day.id
    else
      cell_class << ' empty' unless date.future?
      status_abbr = ''
      value = ''
      id = ''
    end
    if date.today?
      if user.is_work_day?(date) and (begin_of_work = user.begin_of_work(date)).present?
        cell_class << ' work' if time.between?((begin_of_work - 1.hour), begin_of_work)
      else
        cell_class << ' day_off'
      end
    end
    title = ''

    if date.day == date.end_of_month.day
      cell_class << ' salary_day'
      title = faults_tooltip Fault.employee_faults_count_by_kind_on(user, date)
    end
    # good_karmas = user.karmas.good.created_at(date)
    # bad_karmas = user.karmas.bad.created_at(date)
    content_tag(:td, id: (id.present? ? "timesheet_day_#{id}" : ''), title: title, class: cell_class,
                data: {placement: 'right', container: 'body', date: date.to_s, id: id, html: true}) do
      content = ''
      content << content_tag(:span, status_abbr, class: 'status_abbr')
      # content << content_tag(:abbr, "+#{good_karmas.count}", class: 'good_karmas has-tooltip', title: good_karmas.map{|k|k.comment}.join('<br/><br/>'), data: {html: true}) if good_karmas.count > 0
      content << tag(:br)
      content << content_tag(:span, value, class: 'value')
      # content << content_tag(:abbr, "-#{bad_karmas.count}", class: 'bad_karmas has-tooltip', title: bad_karmas.map { |k| k.comment }.join('<br/><br/>'), data: {html: true}) if bad_karmas.count > 0
      content.html_safe
    end
  end

  def faults_tooltip(faults)
    faults.map do |fault_kind, counts|
      presentation = fault_kind.icon.present? ? image_tag(fault_kind.icon, class: 'fault_kind-icon') : fault_kind.name
      "#{presentation} - #{counts[:month]} (#{counts[:total]})"
    end.join('<br/><br/>')
  end
end
