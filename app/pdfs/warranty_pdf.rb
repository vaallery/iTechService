# encoding: utf-8
class WarrantyPdf < Prawn::Document
  require "prawn/measurement_extensions"

  def initialize(sale, view)
    super page_size: 'A4', page_layout: :portrait
    @view = view
    @sale = sale
    @font_height = 10
    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'

    font_size @font_height

    # Organization info
    text [@view.t('sales.warranty_pdf.org_name'), Setting.get_value(:city), Setting.get_value(:address), Setting.get_value(:contact_phone)].join(', '), align: :right, size: 8

    # Logo
    move_down 20
    stroke do
      line_width 2
      horizontal_line 0, 530
    end
    move_up 40
    image File.join(Rails.root, 'app/assets/images/logo.jpg'), width: 80, at: [20, cursor]

    # Contact info
    move_down 45
    font_size 8 do
      bounding_box [400, cursor], width: 130 do
        text 'e-mail: info@itechstore.ru', align: :right
        text 'сайт: http://itechstore.ru', align: :right
        text 'Режим работы:', align: :right
        text Setting.get_value(:warranty_schedule), align: :right
      end
    end

    # Title
    move_up 30
    span 380, position: :right do
      text @view.t('sales.warranty_pdf.title', num: @sale.id, date: @sale.date.strftime('%d.%m.%Y')), size: 12, style: :bold
    end

    # Text
    move_down 40

    text "Все обязательства Сервисного центра по обеспечению гарантийного обслуживания оборудования перечислены в настоящем гарантийном талоне.\nУстановка и настройка программного обеспечения не входит в гарантийные обязательства Сервисного центра и выполняется за отдельную плату.", indent_paragraphs: 30

    text "Гарантийный талон не действителен без печати продавца и подписей.\nОсновные положения:"

    table [
            ['1.', {content: 'Гарантийный срок начинается с даты продажи, указанной продавцом в гарантийном талоне и заверенной его печатью.', colspan: 2}],
            ['2.', {content: 'В течение гарантийного срока при наступлении гарантийного случая Сервисный центр без дополнительной оплаты, не более чем за 45 рабочих дней, исправляет дефекты, либо заменяет дефективные части на новые за исключением дефектов, возникших в результате обстоятельств, предусмотренных в ст. 6 настоящего гарантийного талона.', colspan: 2}],
            ['3.', {content: 'При проведении гарантийного ремонта срок гарантии продлевается на период нахождения оборудования в Сервисном центре.', colspan: 2}],
            ['4.', {content: 'Гарантия не распространяется на расходные и быстроизнашивающиеся материалы: печатающие головки, картриджи, дискеты, красящие ленты, лампы проекторов, кабели и шлейфы, батарейки, расходные материалы и др. а так же на дополнительные аксессуары, входящие в комплект изделия.', colspan: 2}],
            ['5.', {content: 'Оборудование принимается на гарантийный ремонт при наличии гарантийного талона с точным указанием его неисправностей, при наличии драйверов и документации. Если в процессе тестирования указанные клиентом неисправности не подтверждаются, оборудование возвращается клиенту.', colspan: 2}],
            ['6.', {content: 'Гарантия не распространяется на оборудование, которое вышло из строя, либо получило дефекты в следствие:', colspan: 2}],
            ['', '-', 'Несоответствия между напряжением питания товаров и напряжением электрической сети;'],
            ['', '-', 'Действий насекомых или мелких грызунов;'],
            ['', '-', 'Применения не по назначению;'],
            ['', '-', 'Воздействий химических реактивов, либо других активных веществ;'],
            ['', '-', 'Неосторожного использования, приведшего к механическим, электрическим, а также термическим повреждениям, либо к нарушению целостности защитных покрытий;'],
            ['', '-', 'Применения не качественных (не фирменных) расходных материалов, либо носителей информации (дискет, CD-дисков и т.д.), а также при разрушении CD-диска в приводе CD-ROM;'],
            ['', '-', 'Ремонта не специалистами Сервисного центра;'],
            ['', '-', 'Нарушения теплового режима процессора, а также неаккуратной установке радиатора на ядро процессора, приведшее к механическому сколу;'],
            ['', '-', 'Установки не лицензионного программного обеспечения;'],
            ['', '-', 'Эксплуатации в среде, нарушающей требования: температура – от 10С до 40С, влажность – от 10% до 80% (конденсат не допускается), высота – не более 3-х км над уровнем моря, запыленность – 0,05 мг/м2;'],
            ['7.', {content: 'Гарантия распространяется только на товары, серийные номера которых соответствуют номерам, указанным в гарантийном талоне. Целостность гарантийных номеров и фирменных наклеек обязательна.', colspan: 2}],
            ['8.', {content: 'В случае несовместимости приобретенного у нас товара с Вашим оборудованием и программным обеспечением, претензии к проданному товару не принимается.', colspan: 2}],
            ['9.', {content: 'Любой косвенный ущерб, упущенная прибыль и другие косвенные расходы, связанные с появлением недостатков или неисправностей, продавцом не возмещаются.', colspan: 2}],
            ['10.', {content: 'Сервисный центр не отвечает за потерю или уничтожение программных продуктов, баз данных, другой информации, которые произошли в результате выхода из строя товара или его части.', colspan: 2}],
          ], cell_style: {borders: [], padding: 1} do
      column(0).style padding_left: 20, padding_right: 10
      rows(6..15).column(1).style padding_left: 20
      rows(6..15).column(2).style padding_left: 20
    end

    move_down 10
    text "Для получения гарантийного обслуживания необходимо предоставить неисправный товар и гарантийный талон по адресу: #{Setting.get_value(:city)}, #{Setting.get_value(:address)}, #{Setting.get_value(:contact_phone)}, сайт: http://itechstore.ru"

    # Products
    table_data = [['№', 'Артикул', 'Наименование', 'Колич.', 'Характерист.', 'Срок Гарантии']]
    @sale.sale_items.each_with_index do |sale_item, index|
      features = sale_item.features.map(&:value).join(', ')
      table_data += [[index.next.to_s, '', sale_item.name, sale_item.quantity, features, "#{sale_item.warranty_term} мес."]]
      #table_data += [[index.next.to_s, '', sale_item.name, sale_item.quantity, features, "#{sale_item.warranty_term} #{'month'.pluralize(:ru)}"]]
    end
    move_down 10
    table table_data, width: 520, header: true do
      cells.style align: :center
    end
    move_down 10

    # Signs
    group do
      y_pos = cursor
      span 320, position: :left do
        text 'М.П.'
        move_down 5
        text 'Подтверждаю получение укомплектованного и исправного изделия. С условиями предоставления гарантийных обязательств и правилами эксплуатации ознакомлен.'
      end
      move_cursor_to y_pos
      span 200, position: :right do
        text "Подпись продавца /#{@sale.user_fio_short}/______________", align: :right
        move_down 30
        text 'Подпись покупателя ___________________', align: :right
      end
    end

    encrypt_document permissions: { modify_contents: false }
  end

end