# encoding: utf-8
class TicketPdf < Prawn::Document

  def initialize(device, view)
    super top_margin: 10, page_layout: :portrait
    @device = device
    @view = view
    @font_path = "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf"
    @bold_font_path = "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    @bold_font_path = @font_path
    font @font_path
    font_families.update("DejaVuSans" => {bold: @bold_font_path, normal: @font_path})
    client_part
    receiver_part
    encrypt_document permissions: { modify_contents: false }
  end

  def client_part
    image File.join(Rails.root, 'app/assets/images/logo2.png'), width: 100, height: 100, position: -20
    move_up 60
    font_size 18 do
      text "№ #{@device.ticket_number}", align: :center, inlign_format: true
    end
    move_down 40
    text @device.client.name
    move_down 20
    text @view.t('ticket.contacts1')
    text @view.t('ticket.contacts2')
  end

  def receiver_part

  end

end