class SalesImportJob < ActiveJob::Base
  queue_as :default

  def perform(file)
    # import_logs = []
    logs_file = File.new(Rails.root.join('log', "sales_import-#{Time.now.to_s(:number)}.log"), 'w')
    begin
      sheet = FileLoader.open_spreadsheet file
      # import_logs << ['Info', "Import started at #{Time.current.strftime('%Y.%m.%d %H:%M:%S')}"]
      logs_file << ['Info', "Import started at #{Time.current.strftime('%Y.%m.%d %H:%M:%S')}"]
      code_1c = device_type_s = sn = imei = date = qty = nil
      device_type = nil
      9.upto sheet.last_row-1 do |r|
        row = sheet.row r
        # import_logs << ['inverse', "#{r} #{'-'*140}"]
        logs_file << ['inverse', "#{r} #{'-'*140}"]
        case row_type row[0], row[1]
          when :device_type
            # code_1c = RGXP_PRODUCT_CODE_AND_NAME.match(row[0])[1].to_i
            # device_type_s = RGXP_PRODUCT_CODE_AND_NAME.match(row[0])[2]
            code_1c = row[0].to_i
            device_type_s = row[1]
            unless (device_type = DeviceType.find_by_code_1c code_1c).present?
              # import_logs << ['important', "Device type '#{device_type_s}' [#{code_1c}] not found!!!"]
              logs_file << ['important', "Device type '#{device_type_s}' [#{code_1c}] not found!!!"]
            end
          when :device_1
            sn = RGXP_SERIAL_NUMBER.match(row[0])[1]
            imei = nil
            # import_logs << ['info', row[0]]
            logs_file << ['info', row[0]]
          when :device_2
            sn = RGXP_SERIAL_NUMBER_IMEI.match(row[0])[1]
            imei = RGXP_SERIAL_NUMBER_IMEI.match(row[0])[2]
            # import_logs << ['info', row[0]]
            logs_file << ['info', row[0]]
          when :date
            date = RGXP_DATE.match(row[0])[1]
            qty = row[7].to_i
            sale = ImportedSale.find_or_initialize_by serial_number: sn,
                                                      imei: imei,
                                                      sold_at: date.to_date,
                                                      device_type_id: device_type.try(:id),
                                                      quantity: qty

            if sale.new_record?
              if sale.save
                # import_logs << ['success', "#{sale.new_record? ? 'New' : 'Existing'} device #{device_type.try(:full_name)} [#{sale.serial_number}] sold_at: #{sale.sold_at}"]
                logs_file << ['success', "#{sale.new_record? ? 'New' : 'Existing'} device #{device_type.try(:full_name)} [#{sale.serial_number}] sold_at: #{sale.sold_at}"]
              else
                # import_logs << ['error', "Unable to save #{sale.inspect}: #{sale.errors.full_messages.join('. ')}"]
                logs_file << ['error', "Unable to save #{sale.inspect}: #{sale.errors.full_messages.join('. ')}"]
              end
            end
        end
      end
      # import_logs << ['inverse', '-'*160]
      logs_file << ['inverse', '-'*160]
    end
    # ImportMailer.sales_import_log(import_logs).deliver_later
  end

  private

  RGXP_PRODUCT_CODE_AND_NAME = Regexp.new '(\d+) \| (.+)'
  RGXP_PRODUCT_CODE = Regexp.new '\d+'
  RGXP_PRODUCT_NAME = Regexp.new '.+'
  RGXP_SERIAL_NUMBER = Regexp.new '\A([\w\+]+)\Z'
  RGXP_SERIAL_NUMBER_IMEI = Regexp.new '(\w+), (\d+)'
  RGXP_DATETIME = Regexp.new '(\d{2}.\d{2}.\d{4}\ \d{,2}:\d{2}:\d{2})'
  RGXP_DATE = Regexp.new '(\d{2}\.\d{2}\.\d{4})'

  def row_type(val1, val2)
    val1 = val1.to_s
    val2 = val2.to_s
    if RGXP_PRODUCT_CODE === val1 && RGXP_PRODUCT_NAME === val2
      :device_type
    elsif RGXP_SERIAL_NUMBER_IMEI === val1
      :device_2
    elsif RGXP_SERIAL_NUMBER === val1
      :device_1
    elsif RGXP_DATE === val1
      :date
    else
      nil
    end
  end
end
