# encoding: utf-8
class OrderPdf < Prawn::Document
  require "prawn/measurement_extensions"

  def initialize(order, view)
    super page_size: [80.mm, 80.mm], page_layout: :portrait, margin: 10
    @order = order
    @view = view
    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'
    client_part
    start_new_page
    receiver_part
    encrypt_document permissions: { modify_contents: false }
  end

  def client_part
    logo
    vertical_line y-80, y-10, at: 60
    stroke
    font_size 10 do
      text @view.t('ticket.site'), indent_paragraphs: 70
      text @view.t('ticket.email'), indent_paragraphs: 70
      text @view.t('ticket.address1'), indent_paragraphs: 70
      text @view.t('ticket.address2'), indent_paragraphs: 70
      text @view.t('ticket.schedule1'), indent_paragraphs: 70
      text @view.t('ticket.schedule2'), indent_paragraphs: 70
      text @view.t('ticket.schedule3'), indent_paragraphs: 70
    end
    move_down 10
    font_size 24 do
      text "№ #{@order.number}", align: :center, inlign_format: true, style: :bold
    end
    text @order.created_at.strftime('%H:%M %d.%m.%Y'), align: :center
    move_down 10
    text @order.customer_name
    move_down 5
    text @view.t('ticket.contact_phone')
    move_down 5
    horizontal_line 0, 205#, at: y
    stroke
    move_down 5
    font_size 10 do
      text @view.t('ticket.notice')
      text @view.t('ticket.check_status')
    end
  end

  def receiver_part
    logo
    move_down 70
    font_size 24 do
      text "№ #{@order.number}", align: :center, inlign_format: true, style: :bold
    end
    text @order.created_at.strftime('%H:%M %d.%m.%Y'), align: :center
    move_down 20
    text @order.customer_name
  end

  private

  def logo
    image File.join(Rails.root, 'app/assets/images/logo.jpg'), width: 50, height: 50, at: [0, cursor-10]
  end

end