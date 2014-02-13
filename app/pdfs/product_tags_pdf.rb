# encoding: utf-8
class ProductTagsPdf < Prawn::Document
  require 'prawn/measurement_extensions'
  require 'barby/barcode/ean_13'
  require 'barby/outputter/prawn_outputter'

  def initialize(purchase, view, params)
    super page_size: [6.cm, 4.cm], page_layout: :portrait, margin: 4
    @items = purchase.items
    @view = view
    font_families.update 'DroidSans' => {
        normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
        bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'

    @items.each do |item|

    end
    font_size 6 do
      text item.name, align: :center
    end
    if type == :with_price
      move_cursor_to 31
      font_size 10 do
        text view.human_currency(item.actual_price(:sale)).to_s, align: :center
      end
    end
    outputter = Barby::PrawnOutputter.new Barby::EAN13.new(item.barcode_num.chop)
    outputter.annotate_pdf self, height: 14, margin: 5, x: 0, xdim: 1
    move_cursor_to 4
    font_size 4 do
      text item.barcode_num, character_spacing: 3.7
    end
  end

end
