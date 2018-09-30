module FileLoader

  def self.open_spreadsheet(file)
    if file.is_a?(String)
      filename = original_filename = file
    else
      filename = rename_uploaded_file(file)
      original_filename = file.original_filename
    end
    case File.extname(original_filename)
      when ".xls" then Roo::Excel.new(filename)
      when ".xlsx" then Roo::Excelx.new(filename)
      else raise "Unknown file type: #{original_filename}"
    end
  end

  def self.rename_uploaded_file(file)
    begin
      new_file = File.join File.dirname(file.path), file.original_filename
      File.rename file.path, new_file
    rescue SystemCallError => error
      return error.to_s
    end
    return new_file
  end

end