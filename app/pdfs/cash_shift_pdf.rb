# encoding: utf-8
class CashShiftPdf < Prawn::Document
  require 'prawn/measurement_extensions'

  def initialize(cash_shift, view)
    super page_size: [80.mm, 300.mm], page_layout: :portrait, margin: 10
    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'


    move_down 10

    #data = [[view.t('sales.check_pdf.name'), view.t('sales.check_pdf.qty'), view.t('sales.check_pdf.price'), view.t('sales.check_pdf.discount')]]
    #data = data + sale.sale_items.map{|si| [si.name, si.quantity, si.price, si.discount]}
    #data << [view.t('total'), '', sale.calculation_amount]

    #font_size 10
    #table data, width: bounds.width, column_widths: {1 => 8.mm, 2 => 22.mm, 3 => 15.mm} do
    #  cells.style borders: [], padding: 3
    #  columns(1..2).style align: :right
    #end

    encrypt_document permissions: { modify_contents: false }
  end

end