module FieldsHelper
  def date_filter_fields
    start_date_filter_field_tag + ' - '.html_safe +
    end_date_filter_field_tag
  end

  def start_date_filter_field_tag
    text_field_tag :start_date, params[:start_date].try(:strftime, '%d.%m.%Y'), class: 'datepicker input-small', data: {'date-format': 'dd.mm.yyyy', 'date-weekstart': 1}
  end

  def end_date_filter_field_tag
    text_field_tag :end_date, params[:end_date].try(:strftime, '%d.%m.%Y'), class: 'datepicker input-small', data: {'date-format': 'dd.mm.yyyy', 'date-weekstart': 1}
  end
end