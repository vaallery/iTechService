class SalesImport

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    time_format = "%Y.%m.%d %H:%M:%S"
    @import_time = Time.current
    import_logs << ['info', "Import started at [#{import_time.strftime(time_format)}]"]
    if imported_sales.map(&:valid?).all?
      imported_sales.each &:save!
      imported_count = imported_sales.count
      import_logs << ['success', "Imported #{imported_count.to_s}"]
      import_logs << ['info', "Import finished at [#{Time.current.strftime(time_format)}]"]
      true
    else
      imported_sales.each_with_index do |sale, index|
        sale.errors.full_messages.each do |msg|
          errors.add :base, "Row #{index+1} [s/n #{sale.serial_number}]: #{msg}"
        end
      end
      false
    end
  end

  def imported_sales
    @imported_sales ||= load_imported_sales
  end

  def import_logs
    @import_logs ||= []
  end

  def import_time
    @import_time
  end

  private

  RGXP_DEVICE_TYPE = Regexp.new '(\d+) \| (.+)'
  RGXP_DEVICE_1 = Regexp.new '\A(\w+)\Z'
  RGXP_DEVICE_2 = Regexp.new '(\w+), (\d+)'
  RGXP_DATE = Regexp.new '(\d{2}.\d{2}.\d{4}\ \d{,2}:\d{2}:\d{2})'

  def load_imported_sales
    sheet = open_file
    sales = []
    code_1c = device_type_s = sn = imei = date = qty = ''
    device_type = nil
    9.upto sheet.last_row-1 do |r|
      row = sheet.row r
      import_logs << ['inverse', "#{r} #{'-'*140}"]
      case row_type row[0]
        when :device_type
          code_1c = RGXP_DEVICE_TYPE.match(row[0])[1].to_i
          device_type_s = RGXP_DEVICE_TYPE.match(row[0])[2]
          unless (device_type = DeviceType.find_by_code_1c code_1c).present?
            import_logs << ['important', "Device type '#{device_type_s}' [#{code_1c}] not found!!!"]
          end
        when :device_1
          sn = RGXP_DEVICE_1.match(row[0])[1]
          # import_logs << ['info', row[0]]
        when :device_2
          sn = RGXP_DEVICE_2.match(row[0])[1]
          imei = RGXP_DEVICE_2.match(row[0])[2]
          # import_logs << ['info', row[0]]
        when :date
          date = RGXP_DATE.match(row[0])[1]
          qty = row[3].to_i
          sale = ImportedSale.find_or_initialize_by serial_number: sn, imei: imei, sold_at: date.to_date, device_type_id: device_type.try(:id), quantity: qty
          unless !sale.new_record? and sale.sold_at == date.to_date
            sales << sale
            # import_logs << ['success', "#{sale.new_record? ? 'New' : 'Existing'} device #{device_type.try(:full_name)} [#{sale.serial_number}] sold_at: #{sale.sold_at}"]
          end
        else
          # type code here
      end
    end
    import_logs << ['inverse', '-'*160]
    sales
  end

  def row_type(val)
    case val
      when RGXP_DEVICE_TYPE then :device_type
      when RGXP_DEVICE_1 then :device_1
      when RGXP_DEVICE_2 then :device_2
      when RGXP_DATE then :date
      else nil
    end
  end

  def open_file
    filename = rename_uploaded_file file
    case File.extname file.original_filename
      when '.xls' then Roo::Excel.new filename, nil, :ignore
      when '.xlsx' then Roo::Excelx.new filename, nil, :ignore
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def rename_uploaded_file(file)
    begin
      new_file = File.join File.dirname(file.path), file.original_filename
      File.rename file.path, new_file
    rescue SystemCallError => error
      return error.to_s
    end
    new_file
  end

end