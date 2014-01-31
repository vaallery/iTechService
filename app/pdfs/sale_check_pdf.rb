# encoding: utf-8
class SaleCheckPdf < Prawn::Document
  require 'prawn/measurement_extensions'

  def initialize(sale, view, is_copy=false)
    super page_size: [80.mm, 100.mm], page_layout: :portrait, margin: 10
    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'

    if is_copy
      text view.t('sales.check_num_datetime_copy', num: sale.id, datetime: view.human_datetime(sale.date))
    else
      text view.t('sales.check_num_datetime', num: sale.id, datetime: view.human_datetime(sale.date))
    end
    move_down 10

    data = sale.sale_items.map{|si| [si.name, si.price, si.discount]}
    data << [view.t('total'), sale.calculation_amount]

    font_size 10
    table data, width: bounds.width do
      cells.style borders: []
      columns(1..2).style align: :right
    end

    encrypt_document permissions: { modify_contents: false }
  end

end