# encoding: utf-8
class CashShiftPdf < Prawn::Document
  require 'prawn/measurement_extensions'

  def initialize(cash_shift, view)
    @font_height = 10
    @cash_shift = cash_shift
    @view = view
    super page_size: [227, 380], page_layout: :portrait, margin: [10, 24, 10, 10]
    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'
    font_size @font_height

    image cash_shift.department.logo_path, width: 30, at: [0, cursor]
    move_down @font_height/2
    text @cash_shift.department.city, align: :center
    text @cash_shift.department.address, align: :center
    text view.t('sales.check_pdf.greeting'), align: :center
    move_down @font_height
    draw_divider
    text @view.t('cash_shifts.pdf.title', num: @cash_shift.id), align: :center
    text @cash_shift.user_short_name, align: :center
    draw_divider

    # Sales
    text @view.t('cash_shifts.pdf.sales_section')
    report_row @view.t('cash_shifts.pdf.sales'), @cash_shift.sales_total, indent_paragraphs: 10, style: :bold
    @cash_shift.sales_total_by_kind.each do |kind_total|
      report_row @view.t("payments.kinds.#{kind_total[0]}"), kind_total[1], indent_paragraphs: 20
    end
    draw_divider

    # Returns
    report_row @view.t('cash_shifts.pdf.returns'), @cash_shift.sales_total(true), indent_paragraphs: 10, style: :bold
    @cash_shift.sales_total_by_kind(true).each do |kind_total|
      report_row @view.t("payments.kinds.#{kind_total[0]}"), kind_total[1], indent_paragraphs: 20
    end
    draw_divider

    # Cash operations
    report_row @view.t('cash_shifts.pdf.pay_in'), @cash_shift.cash_operations_total, style: :bold
    report_row @view.t('cash_shifts.pdf.pay_out'), @cash_shift.cash_operations_total(true), style: :bold
    draw_divider

    # Quantity
    text @view.t('cash_shifts.pdf.sales_section')
    report_row @view.t('cash_shifts.pdf.sales'), @cash_shift.sales_count, indent_paragraphs: 10
    report_row @view.t('cash_shifts.pdf.returns'), @cash_shift.sales_count(true), indent_paragraphs: 10
    draw_divider

    # Encashment
    text @view.t('cash_shifts.pdf.encashment')
    @cash_shift.encashments_by_kind.each do |encashment_kind|
      report_row @view.t("payments.kinds.#{encashment_kind[0]}"), encashment_kind[1], indent_paragraphs: 10
    end
    report_row @view.t('cash_shifts.pdf.shift_total'), @cash_shift.encashment_total, style: :bold
    draw_divider

    #text "#{view.t('sales.check_pdf.doc')} #{cash_shift.id}"
    #move_up font.height
    text cash_shift.closed_at.strftime('%d-%m-%y %H:%M'), align: :right if cash_shift.is_closed

    encrypt_document permissions: { modify_contents: false }
  end

  private

  def report_row(title, value, options={})
    text title, options
    move_up @font_height
    text (value.is_a?(Integer) ? value.to_s : currency_str(value)), options.merge(align: :right)
  end

  def currency_str(number)
    sprintf('%.2f', number || 0).gsub('.', ',')
  end

  def draw_divider
    stroke { horizontal_line 0, 210 }
    move_down 5
  end

end