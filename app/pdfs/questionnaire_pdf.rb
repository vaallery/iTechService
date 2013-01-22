# encoding: utf-8
class QuestionnairePdf < Prawn::Document
  require 'prawn/measurement_extensions'

  def initialize view
    super page_size: 'A4'
    @view = view
    @card_number = "329348392"
    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'

    # Title
    span 350, position: :right do
      text "Анкета для получения карты постоянного гостя", size: 20, style: :bold
    end

    # Fields
    move_down 20
    font_size 14
    draw_field 'Номер карты', @card_number
    draw_field 'Фамилия', @surname
    draw_field 'Имя', @name
    draw_field 'Отчество', @patronymic
    draw_field 'e-mail', @email
    draw_field 'Номер телефона', @full_phone_number, :phone
    draw_field 'Дата рождения', @birthday, :date
    draw_field 'Даю согласие на получение информационных рассылок', ''

    #logo

    encrypt_document permissions: { modify_contents: false }
  end

  private

  def logo
    move_to 0, 0
    image File.join(Rails.root, 'app/assets/images/logo2.png'), width: 120, height: 120
  end

  def draw_field(name, content, type=:usual)
    case type
      when :usual
        #length = 21
        content = content.chars.to_a
    end
    table [[name] + content], width: bounds.width do
      columns(0).style borders: [], align: :right
      columns(1..-1).style width: 20, border_top_width: 2, border_bottom_width: 2
      column(1).border_left_width = 2
      column(-1).border_right_width = 2
    end
  end

end