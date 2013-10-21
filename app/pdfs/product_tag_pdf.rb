# encoding: utf-8
class ProductTagPdf < Prawn::Document
  require 'prawn/measurement_extensions'
  require 'barby/barcode/ean_13'
  require 'barby/outputter/prawn_outputter'

  def initialize(item, view, type=nil)
    super page_size: [3.cm, 2.cm], page_layout: :portrait, margin: 4
    @item = item
    @view = view
    font_families.update 'DroidSans' => {
        normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
        bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'
    font_size 6 do
      text item.name, align: :center
    end
    if type == :with_price
      move_cursor_to 31
      font_size 10 do
        text view.human_currency(item.actual_price(:sale)).to_s, align: :center
      end
    end
    outputter = Barby::PrawnOutputter.new item.barcode
    outputter.annotate_pdf self, height: 14, margin: 5, x: 0
    move_cursor_to 4
    font_size 4 do
      text item.barcode.to_s, character_spacing: 3.7
    end
  end

end
