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
      text view.t('sales.check_pdf.title_copy', num: sale.id, datetime: view.human_datetime(sale.date))
    else
      text view.t('sales.check_pdf.title', num: sale.id, datetime: view.human_datetime(sale.date))
    end
    move_down 10

    data = [[view.t('sales.check_pdf.name'), view.t('sales.check_pdf.qty'), view.t('sales.check_pdf.price'), view.t('sales.check_pdf.discount')]]
    data = data + sale.sale_items.map{|si| [si.name, si.quantity, si.price, si.discount]}
    data << [view.t('total'), '', sale.calculation_amount]

    font_size 10
    table data, width: bounds.width, column_widths: {1 => 8.mm, 2 => 22.mm, 3 => 15.mm} do
      cells.style borders: [], padding: 3
      columns(1..2).style align: :right
    end

    encrypt_document permissions: { modify_contents: false }
  end

end