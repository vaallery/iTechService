# encoding: utf-8
class OrderPdf < Prawn::Document
  require "prawn/measurement_extensions"

  def initialize(order, view)
    super page_size: [80.mm, 90.mm], page_layout: :portrait, margin: 10
    @order = order
    @view = view
    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'
    client_part
    encrypt_document permissions: { modify_contents: false }
  end

  def client_part
    logo
    vertical_line y-80, y-10, at: 60
    stroke
    font_size 10 do
      text @view.t('tickets.site'), indent_paragraphs: 70
      text @view.t('tickets.email'), indent_paragraphs: 70
      text Setting.get_value(:city), indent_paragraphs: 70
      text Setting.get_value(:address), indent_paragraphs: 70
      text Setting.get_value(:schedule), indent_paragraphs: 70
    end
    move_down 4
    font_size 24 do
      text @view.t('orders.order_num', num: @order.number), align: :center, inlign_format: true, style: :bold
    end
    text @order.created_at.strftime('%H:%M %d.%m.%Y'), align: :center, size: 10
    move_down 4
    text @order.object, style: :bold
    move_down 5
    text (@order.user || @view.current_user).short_name
    text Setting.get_value(:contact_phone)
    move_down 5
    horizontal_line 0, 205#, at: y
    stroke
    move_down 5
    font_size 10 do
      text @view.t('tickets.notice_order')
      text @view.t('tickets.check_status_order')
    end
  end

  private

  def logo
    image File.join(Rails.root, 'app/assets/images/logo.jpg'), width: 50, height: 50, at: [0, cursor-10]
  end

end