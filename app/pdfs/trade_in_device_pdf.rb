require 'prawn/measurement_extensions'

class TradeInDevicePdf < Prawn::Document
  include ActiveSupport::NumberHelper

  attr_reader :device, :filename, :filepath

  def initialize(device)
    @device = device
    @filename = "trade_in_device_#{device.number}.pdf"
    @filepath = Rails.root.join('tmp', 'pdf', filename)
    super page_size: [72.mm, 160.mm], page_layout: :portrait, margin: [10, 22, 10, 10]

    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }

    font 'DroidSans'

    table_data = [
      [t_attribute(:number), device.number],
      [t_attribute(:item), item],
      [t_attribute(:appraised_value), appraised_value],
      [t_attribute(:bought_device), device.bought_device],
      [t_attribute(:client_name), device.client_name],
      [t_attribute(:client_phone), device.client_phone],
      [t_attribute(:check_icloud), device.check_icloud],
      [t_attribute(:appraiser), device.appraiser],
      [t_attribute(:received_at), received_at],
    ]

    table table_data
  end

  def render_file
    super filepath
  end

  private

  def item
    device.name
  end

  def appraised_value
    number_to_currency device.appraised_value
  end

  def received_at
    I18n.l device.received_at, format: :date
  end

  def t_attribute(name)
    TradeInDevice.human_attribute_name(name)
  end
end