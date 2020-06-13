# encoding: utf-8
class OrderPdf < Prawn::Document
  require "prawn/measurement_extensions"

  attr_reader :order, :department, :view

  def initialize(order, view)
    super page_size: [80.mm, 90.mm], page_layout: :portrait, margin: 10
    @order = order
    @department = order.department
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
      span 135, position: :right do
        text @view.t('tickets.site')
        text @view.t('tickets.email')
        text Setting.address_for_check(department)
        text Setting.schedule(department)
      end
    end
    move_down 4
    font_size 24 do
      text @view.t('orders.order_num', num: order.number), align: :center, inlign_format: true, style: :bold
    end
    text order.created_at.strftime('%H:%M %d.%m.%Y'), align: :center, size: 10
    move_down 4
    text order.object, style: :bold
    move_down 5
    text (order.user || @view.current_user).short_name
    text Setting.contact_phone(department)
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
    return unless department.logo_path

    image department.logo_path, width: 50, at: [0, cursor-10]
  end
end
