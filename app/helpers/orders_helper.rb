module OrdersHelper

  def row_class_for_order order
    case order.status
      when 'new' then row_class = 'info'
      when 'pending' then row_class = 'warning'
      when 'done' then row_class = 'success'
      when 'canceled' then row_class = 'error'
    end
  end

end
