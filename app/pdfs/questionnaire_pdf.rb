# encoding: utf-8
class QuestionnairePdf < Prawn::Document
  require 'prawn/measurement_extensions'

  def initialize view, data
    super page_size: 'A4'
    @view = view
    @card_number = data[:card_number]
    @surname = data[:surname]
    @name = data[:name]
    @patronymic = data[:patronymic]
    @email = data[:email]
    @full_phone_number = data[:full_phone_number]
    @birthday = data[:birthday].to_date
    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'

    # Logo
    image File.join(Rails.root, 'app/assets/images/logo.jpg'), width: 80, at: [20, cursor]

    # Title
    move_down 20
    span 380, position: :right do
      text "Анкета для получения карты постоянного гостя", size: 20, style: :bold
    end

    # Fields
    move_down 40
    font_size 12
    draw_field 'Номер карты', @card_number, :limited
    draw_field 'Фамилия', @surname
    draw_field 'Имя', @name
    draw_field 'Отчество', @patronymic
    draw_field 'e-mail', @email
    draw_field 'Номер телефона', @full_phone_number, :phone
    draw_field 'Дата рождения', @birthday, :date
    move_down 10
    span 200, position: :right do
      text 'Указав дату рождения, вы можете рассчитывать на скидку в этот день.', size: 10, align: :right
    end
    draw_field 'Даю согласие на получение информационных рассылок', ' ', length: 1

    # Agreement
    move_down 40
    text 'Настоящим договором даю свое согласие на обработку моих личных данных компании «iTech» '+
        '(директор – Колесник Виталий Валерьевич, адрес: Некрасовская, 48А) и подтверждаю, '+
        'что, давая такое согласие, я действую своей волей и в своих интересах.', align: :justify
    move_down 12
    text 'Согласие дается мною в целях получения информации о товарах и услугах, предоставляемых компанией '+
        'и распространяется на следующую информацию:', align: :justify
    move_down 12
    text 'ФИО, дата рождения, e-mail, телефон (домашний, служебный, сотовый).', align: :justify
    move_down 12
    text 'Настоящее согласие предоставляется на осуществление любых действий в отношении моих персональных данных, '+
         'которые необходимы или желаемы для достижения указанных выше целей, включая (без ограничения) сбор, '+
         'систематизацию, накопление, хранение, уточнение (обновление, изменение), использование, распространение '+
         '(в том числе передача), обезличивание, блокирование, уничтожение, трансграничную передачу персональных '+
             'данных, а также осуществление любых иных действий с моими персональными данными с учетом федерального '+
             'законодательства. В случае неправомерного использования предоставленных мною персональных данных '+
             'согласие отзывается моим письменным заявлением.', align: :justify
    move_down 12
    text 'Данное согласие действует с «_____»___________ ______г. бессрочно.'
    move_down 60
    horizontal_line 0, 235
    stroke
    text '(Ф.И.О., подпись лица, давшего согласие)'

    # Logo


    encrypt_document permissions: { modify_contents: false }
  end

  private

  def draw_field(name, content, type=:usual, length=nil)
    case type
      when :usual then content = content.ljust(21) unless length
      when :phone then content = '+'+content.ljust(11)
      when :date then content = content.strftime '%d.%m.%y'
    end
    content = content.chars.to_a
    move_down 10
    table [[name] + content], width: bounds.width do
      columns(0).style borders: [], align: :right
      columns(1..-1).style border_top_width: 2, border_bottom_width: 2, align: :center, width: 22
      column(1).border_left_width = 2
      column(-1).border_right_width = 2
      #columns([2,5]).style borders: [:left, :right], width: 5 if type == :date
      if type == :date
        cells.columns(1..-1).filter do |cell|
          cell.content == '.'
        end.style width: 15, borders: [:left, :right], border_left_width: 2, border_right_width: 2
      end
    end
  end

end