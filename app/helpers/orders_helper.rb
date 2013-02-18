module OrdersHelper

  def row_class_for_order order
    case order.status
      when 'new' then row_class = 'info'
      when 'pending' then row_class = 'warning'
      when 'done' then row_class = 'success'
      when 'canceled' then row_class = 'error'
    end
  end

  def order_row_tag(order)
    content_tag(:tr, class: row_class_for_order(order), data: {order_id: order.id}) do
      content_tag(:td, link_to(order.number, order_path(order)), class: 'order_number_column') +
      content_tag(:td, t("orders.statuses.#{order.status}"), class: 'order_status_column') +
      content_tag(:td, t("orders.object_kinds.#{order.object_kind}"), class: 'order_object_kind_column') +
      content_tag(:td, order.object, class: 'order_object_column') +
      content_tag(:td, class: 'order_customer_column') do
        if order.customer_type == 'User'
          order.customer_presentation
        else
          (order.customer.present? ? link_to(order.customer_presentation, client_path(order.customer)) : '-')
        end.html_safe +
        tag(:br, false) +
        order.comment
      end +
      content_tag(:td, l(order.created_at, format: :long_d), class: 'order_created_at_column') +
      content_tag(:td, class: 'order_actions_column') do
        link_to(icon_tag('edit'), edit_order_path(order), class: 'btn btn-small')
      end
    end.html_safe
  end

end
