# encoding: utf-8
class TicketPdf < Prawn::Document
  require "prawn/measurement_extensions"

  def initialize(device, view)
    super page_size: [80.mm, 80.mm], page_layout: :portrait, margin: 10
    @device = device
    @view = view
    @font_normal = "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf"
    @font_bold = "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    #@bold_font_path = @font_path
    font @font_normal
    font_families.update("DejaVuSans" => {bold: @font_bold, normal: @font_normal})
    client_part
    start_new_page
    receiver_part
    encrypt_document permissions: { modify_contents: false }
  end

  def client_part
    logo
    vertical_line y+70, y, at: 60
    stroke
    move_up 80
    font_size 10 do
      text @view.t('ticket.site'), indent_paragraphs: 70
      text @view.t('ticket.email'), indent_paragraphs: 70
      text @view.t('ticket.address1'), indent_paragraphs: 70
      text @view.t('ticket.address2'), indent_paragraphs: 70
      text @view.t('ticket.schedule1'), indent_paragraphs: 70
      text @view.t('ticket.schedule2'), indent_paragraphs: 70
      text @view.t('ticket.schedule3'), indent_paragraphs: 70
    end
    move_down 20
    font_size 24 do
      font @font_bold
      text "№ #{@device.ticket_number}", align: :center, inlign_format: true
    end
    font @font_normal
    text @device.created_at.strftime('%H:%M %d.%m.%Y'), align: :center
    move_down 10
    #text @device.user_name
    text "Виталий"
    move_down 5
    text @view.t('ticket.contact_phone')
    move_down 5
    horizontal_line 0, 205#, at: y
    stroke
    move_down 5
    font_size 10 do
      text @view.t('ticket.notice')
    end
  end

  def receiver_part
    logo
    move_up 66
    font_size 24 do
      font @font_bold
      text "№ #{@device.ticket_number}", align: :center, inlign_format: true
    end
    font @font_normal
    text @device.created_at.strftime('%H:%M %d.%m.%Y'), align: :center
    move_down 30
    text @device.client_name
    move_down 5
    text @view.t('ticket.operations_list')
    text @device.tasks.map{|t|t.id}.join(', ')
    move_down 5
    #text @device.user_name
    text "Виталий"
  end

  private

  def logo
    image File.join(Rails.root, 'app/assets/images/logo2.png'), width: 80, height: 80, position: -15, vposition: -10
  end

end