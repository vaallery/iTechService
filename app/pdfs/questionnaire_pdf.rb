# encoding: utf-8
class QuestionnairePdf < Prawn::Document
  require 'prawn/measurement_extensions'

  def initialize view
    super page_size: 'A4'
    @view = view
    @font_normal = "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf"
    @font_bold = "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    font @font_normal
    font_families.update("DejaVuSans" => {bold: @font_bold, normal: @font_normal})

    encrypt_document permissions: { modify_contents: false }
  end

end