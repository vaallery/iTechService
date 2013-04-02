module InfosHelper

  def info_row_class(info)
    class_s = ''
    class_s << ' warning' if info.important?
    class_s << ' error' if info.private?
    class_s
  end

end
