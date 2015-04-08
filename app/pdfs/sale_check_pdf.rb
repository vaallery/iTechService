# encoding: utf-8
class SaleCheckPdf < Prawn::Document
  require 'prawn/measurement_extensions'

  def initialize(sale, is_copy=false)
    @sale = sale
    @is_copy = is_copy
    @font_height = 10

    super page_size: [227, page_height], page_layout: :portrait, margin: [10, 24, 10, 10]
    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'
    font_size @font_height

    image File.join(Rails.root, 'app/assets/images/logo.jpg'), width: 30, height: 30, at: [0, cursor]
    move_down @font_height/2
    span 150, position: :center do
      text Setting.get_value(:address_for_check), align: :center
      text I18n.t('sales.check_pdf.greeting'), align: :center
    end
    move_down @font_height
    stroke { horizontal_line 0, 205 }
    move_down 5

    text [I18n.t("sales.check_pdf.#{sale.is_return ? 'return' : 'sale'}"), is_copy ? "(#{I18n.t('sales.check_pdf.copy')})" : nil].join(' ')
    move_up font.height
    text sale.user_short_name, align: :right
    text "#{I18n.t('sales.check_pdf.open')} #{sale.created_at.localtime.strftime('%H:%M:%S')}", align: :center

    move_down 5
    stroke { horizontal_line 0, 205 }
    move_down 5

    items_strings.each do |string|
      text string
      move_down 2
    end
    stroke { horizontal_line 0, 205 }
    move_down font.height

    text I18n.t('sales.payment')
    sale.payments.each do |payment|
      text I18n.t("payments.kinds.#{payment.kind}"), indent_paragraphs: 10
      move_up font.height
      text "#{currency_str(payment.value)}", align: :right
      move_down 2
    end

    text I18n.t('sales.check_pdf.discount')
    move_up font.height
    text "#{currency_str(sale.total_discount)}", align: :right
    move_down font.height

    font_size @font_height*1.6 do
      text I18n.t('sales.check_pdf.total')
      move_up font.height
      text "#{currency_str(sale.calculation_amount)}", align: :right
    end
    move_down font.height

    text "##{sale.cash_shift_id} #{I18n.t('sales.check_pdf.doc')} #{sale.id}"
    move_up font.height
    text sale.date.localtime.strftime('%d-%m-%y %H:%M'), align: :right

    text I18n.t('sales.check_pdf.thanks1'), align: :center
    text I18n.t('sales.check_pdf.thanks2'), align: :center

    encrypt_document permissions: { modify_contents: false }
  end

  def page_height_mm
    page_height / 1.mm
  end

  private

  def currency_str(number)
    sprintf('%.2f', number).gsub('.', ',')
  end

  def items_strings
    @items_strings ||= load_items_strings
  end

  def load_items_strings
    strings = []
    @sale.sale_items.each_with_index do |sale_item, index|
      name = sale_item.name
      if sale_item.feature_accounting
        features = sale_item.features.map(&:value).join(', ')
        name = name + " (#{features})"
      end
      strings << "#{index+1}. #{name}   #{sale_item.quantity} #{I18n.t('sales.check_pdf.po')} #{currency_str(sale_item.price)}"
    end
    strings
  end

  def page_height
    line_height = @font_height+2
    items_lines_count = items_strings.sum{|str|str.length/25}
    payments_count = @sale.payments.count
    210 + items_lines_count*line_height + payments_count*line_height
  end

end