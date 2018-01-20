# encoding: utf-8
class ProductTagsPdf < Prawn::Document
  require 'prawn/measurement_extensions'
  require 'barby/barcode/ean_13'
  require 'barby/outputter/prawn_outputter'

  def initialize(purchase, view, params)
    super page_size: [28.mm, 20.mm], page_layout: :portrait, margin: 4
    @view = view
    items = purchase.batches
    font_families.update 'DroidSans' => {
        normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
        bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'
    items.each do |item|
      title = ''
      title << "#{item.code}: " if params[:with_price].blank?
      title << item.name
      title << "(#{item.features.map(&:value).join(', ')})" if item.feature_accounting
      price = params[:with_price] ? item.retail_price : nil
      if params[:by_qty]
        item.quantity.times do
          item_tag title, item.barcode_num, price
        end
      else
        item_tag title, item.barcode_num, price
      end
    end
  end

  private

  def currency_str(number)
    @view.number_to_currency number, precision: 0, delimiter: ' ', separator: ',', unit: ''
  end

  def draw_barcode(number, options={})
    outputter = Barby::PrawnOutputter.new Barby::EAN13.new(number.chop)
    outputter.annotate_pdf self, options.merge(height: 14, x: 0, xdim: 0.8)
  end

  def item_tag(title, barcode_num, price=nil)
    if price.nil?
      font_size 6
      text title, align: :center
      draw_barcode barcode_num, margin: 8
      move_cursor_to 7
      text barcode_num, character_spacing: 2
    else
      font_size 5
      text title, align: :center
      move_down 1
      stroke { horizontal_line 0, 3.cm }
      move_cursor_to 29
      font_size 10 do
        text currency_str(price).to_s, align: :center, style: :bold
        move_up 8
        text @view.t('number.currency.format.unit'), align: :right, size: 6
      end
      draw_barcode barcode_num, margin: 5
      move_cursor_to 4
      font_size 4 do
        text barcode_num, character_spacing: 3.7
      end
    end
  end

end
