# encoding: utf-8
class GiftCertificatePdf < Prawn::Document
  require "prawn/measurement_extensions"

  def initialize(certificate, view, consume)
    super page_size: [80.mm, 90.mm], page_layout: :portrait, margin: 10
    font_families.update 'DroidSans' => {
        normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
        bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'
    font_size 14
    text view.t('activerecord.models.gift_certificate')
    text "№ #{certificate.number}"
    text "#{view.l certificate.updated_at, format: :long_d}"
    text "#{GiftCertificate.human_attribute_name(:consumed)}: #{view.number_to_currency consume, precision: 0}"
    encrypt_document permissions: { modify_contents: false }
  end

end