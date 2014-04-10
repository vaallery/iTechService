module PrinterTools

  def self.print_file(filepath, type=nil, height=nil)
    if File.exists? filepath
      options = '-o PageCutType=1PartialCutPage'
      case type.to_sym
        when :sale_check then options << " -o media=Custom.72x#{height || 200}mm"
        when :ticket then options << ' -o media=Custom.72x90mm'
        when :quick_order then options << ' -o media=Custom.72x90mm'
        else options << ' -o media=Custom.72x90mm'
      end
      puts "#{options} #{filepath}"
      system "lp #{options} #{filepath}"
    end
  end


end