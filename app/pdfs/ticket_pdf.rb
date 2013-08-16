# encoding: utf-8
class TicketPdf < Prawn::Document
  require 'prawn/measurement_extensions'
  require 'barby/barcode/ean_13'
  require 'barby/outputter/prawn_outputter'

  def initialize(device, view, part=nil)
    super page_size: [80.mm, 90.mm], page_layout: :portrait, margin: 10
    @device = device
    @view = view
    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'
    client_part unless part.to_i == 2
    start_new_page if part.nil?
    receiver_part unless part.to_i == 1
    encrypt_document permissions: { modify_contents: false }
  end

  def client_part
    logo
    vertical_line y-80, y-10, at: 60
    stroke
    font_size 10 do
      text @view.t('tickets.site'), indent_paragraphs: 70
      text @view.t('tickets.email'), indent_paragraphs: 70
      text Setting.get_value(:address), indent_paragraphs: 70
      text Setting.get_value(:schedule), indent_paragraphs: 70
    end
    move_down 10
    font_size 24 do
      text "№ #{@device.ticket_number}", align: :center, inlign_format: true, style: :bold
    end
    text @device.created_at.strftime('%H:%M %d.%m.%Y'), align: :center
    move_down 5
    text @device.user_short_name
    move_down 5
    text Setting.get_value(:contact_phone)
    move_down 5
    horizontal_line 0, 205
    stroke
    move_down 5
    font_size 10 do
      text @view.t('tickets.notice')
      text @view.t('tickets.check_status')
    end
    barcode
  end

  def receiver_part
    logo
    move_down 70
    font_size 24 do
      text "№ #{@device.ticket_number}", align: :center, inlign_format: true, style: :bold
    end
    text @device.created_at.strftime('%H:%M %d.%m.%Y'), align: :center
    move_down 20
    text @device.client_short_name
    move_down 5
    text @view.t('tickets.operations_list')
    text @device.tasks.map{|t|t.id}.join(', ')
    move_down 5
    text @device.user_short_name
  end

  private

  def logo
    image File.join(Rails.root, 'app/assets/images/logo.jpg'), width: 50, height: 50, at: [0, cursor-10]
  end

  def barcode
    num = @device.ticket_number
    code = '0'*(12-num.length) + num
    code = Barby::EAN13.new code
    outputter = Barby::PrawnOutputter.new code
    outputter.annotate_pdf self, height: 25, xdim: 1.7, x: 20, margin: 2
  end

end