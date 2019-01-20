class ReceiptPdf < Prawn::Document
  require 'prawn/measurement_extensions'
  include ActionView::Helpers::NumberHelper
  attr_accessor :sale

  def initialize(sale)
    super page_size: 'A4', page_layout: :portrait
    @sale = sale
    @font_height = 9
    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'

    font_size @font_height

    header
    products_table
    footer
  end

  private

  def header
    # Organization info
    move_down 10
    text [Setting.get_value(:organization, sale.department).presence || t(:org_name), "г. #{sale.department.city}", sale.department.address, "Конт. тел.: #{sale.department.contact_phone}"].join(', '), align: :right, size: 8

    # Logo
    move_down 15
    stroke do
      line_width 2
      horizontal_line 0, 530
    end
    move_up 40
    image File.join(Rails.root, 'app/assets/images/logo.jpg'), width: 80, at: [20, cursor]

    # Title
    move_down 60
    span 380, position: :right do
      text t(:title, num: sale.number, date: sale.date.localtime.strftime('%d.%m.%Y')), size: 12, style: :bold
    end

    # Contact info
    move_up 28
    font_size 8 do
      bounding_box [400, cursor], width: 130 do
        text 'e-mail: info@itechstore.ru', align: :right
        text 'сайт: http://itechstore.ru', align: :right
        text 'Режим работы:', align: :right
        text sale.department.schedule, align: :right
      end
    end

    move_down 20
  end

  def products_table
    total_sum = 0
    data = [[t(:num), t(:article), t(:product_name), t(:serial_number), t(:imei),
             t(:price), t(:measure), t(:quantity), t(:sum)]]
    sale.sale_items.each_with_index do |sale_item, index|
      sum = sale_item.price * sale_item.quantity
      data << [index.next.to_s, sale_item.code, sale_item.name, sale_item.serial_number, sale_item.imei,
               number_to_currency(sale_item.price), sale_item.measure, sale_item.quantity, number_to_currency(sum)]
      total_sum += sum
    end
    table data, width: 520, header: true do
      cells.style align: :center
    end
    move_down 10
    default_leading 5
    text t(:products_total, qty: sale.sale_items.size, sum: number_to_currency(total_sum))
    text t(:sum_in_words, sum: sale.sum_in_words)
  end

  def footer
    text "#{t(:customer)}: #{sale.customer}"
    text t(:sold, seller: sale.seller)
    text t(:seller_post, name: sale.seller_post)
    move_up 7
    draw_text t(:sign), at: [280, cursor]
    move_down 50
  end

  def t(key, options = {})
    options.merge! scope: 'pdfs.receipt'
    I18n.t key, options
  end
end
