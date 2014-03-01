module FileLoader

  def self.open_spreadsheet(file)
    filename = rename_uploaded_file file
    case File.extname(file.original_filename)
      when ".xls" then Roo::Excel.new(filename, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
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