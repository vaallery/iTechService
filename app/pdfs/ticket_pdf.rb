class TicketPdf < Prawn::Document
  require 'prawn/measurement_extensions'
  require 'barby/barcode/ean_13'
  require 'barby/outputter/prawn_outputter'

  def initialize(service_job, view, part=nil)
    super page_size: [80.mm, 90.mm], page_layout: :portrait, margin: [10, 22, 10, 10]
    @service_job = service_job
    @view = view
    font_families.update 'DroidSans' => {
      normal: "#{Rails.root}/app/assets/fonts/droidsans-webfont.ttf",
      bold: "#{Rails.root}/app/assets/fonts/droidsans-bold-webfont.ttf"
    }
    font 'DroidSans'
    client_part unless part.to_i == 2
    start_new_page if part.nil?
    receiver_part unless part.to_i == 1
    encrypt_document permissions: { modify_contents: false }
  end

  def client_part
    logo
    vertical_line y-80, y-10, at: 60
    stroke
    font_size 10 do
      span 125, position: :right do
        text @view.t('tickets.site')
        text @view.t('tickets.email')
        text Setting.get_value(:address_for_check)
        text Setting.get_value(:schedule)
      end
    end
    move_cursor_to 160
    font_size 24 do
      text "№ #{@service_job.ticket_number}", align: :center, inlign_format: true, style: :bold
    end
    text @service_job.created_at.localtime.strftime('%H:%M %d.%m.%Y'), align: :center
    move_down 5
    text @view.t('tickets.user', name: @service_job.user_short_name)
    move_down 5
    text Setting.get_value(:contact_phone)
    move_down 5
    horizontal_line 0, 205
    stroke
    move_down 5
    font_size 10 do
      text @view.t('tickets.notice')
      text @view.t('tickets.check_status')
    end
    barcode
  end

  def receiver_part
    logo
    move_down 26
    font_size 22 do
      text @service_job.ticket_number, align: :right, inlign_format: true, style: :bold
    end
    text @service_job.created_at.localtime.strftime('%H:%M %d.%m.%Y'), align: :center
    move_down 15
    text @service_job.client_short_name
    text @view.number_to_phone @service_job.client.full_phone_number || @service_job.client.phone_number, area_code: true
    text "#{@view.t('tickets.service_job_contact_phone', number: @view.number_to_phone(@service_job.contact_phone, area_code: true))}"
    move_down 5
    text "#{ServiceJob.human_attribute_name(:security_code)}: #{@service_job.security_code}"
    move_down 5
    text @view.t('tickets.operations_list')
    text @service_job.tasks.map{|t|t.name}.join(', ')
    move_down 5
    text @view.t('tickets.user', name: @service_job.user_short_name)
    barcode
  end

  private

  def logo
    image File.join(Rails.root, 'app/assets/images/logo.jpg'), width: 50, height: 50, at: [0, cursor-10]
  end

  def barcode
    num = @service_job.ticket_number
    code = '0'*(12-num.length) + num
    code = Barby::EAN13.new code
    outputter = Barby::PrawnOutputter.new code
    outputter.annotate_pdf self, height: 25, xdim: 1.7, x: 20, margin: 2
  end

end
