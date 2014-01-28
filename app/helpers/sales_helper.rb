module SalesHelper

  def options_for_sale_kind_select(kind=false)
    options_for_select %w[sale return return_check].map { |k| [t("sales.kinds.#{k}"), k] }, kind
  end

  def link_to_post_sale(sale)
    if !@sale.is_postable?
      link_to t('sales.close_check'), '#', id: 'sale_close_check', class: 'btn', disabled: true
    else
      link_to t('sales.close_check'), post_sale_path(@sale), method: 'put', id: 'sale_close_check', class: 'btn', data: {confirm: t('confirmation')}
    end
  end

  def link_to_cancel_sale(sale)
    if sale.new_record?
      link_to t('sales.cancel_check'), '#', id: 'sale_cancel_check', class: 'btn', disabled: true
    else
      link_to t('sales.cancel_check'), cancel_sales_path(sale_id: @sale.id), method: 'post', id: 'sale_cancel_check', class: 'btn'
    end
  end

  def link_to_payment(sale)
    if sale.new_record? or sale.sale_items.empty?
      link_to t('sales.payment'), '#', id: '', class: 'btn', disabled: true
    elsif sale.payments.any?
      link_to t('sales.payment'), sale_payments_path(sale_id: sale.id), remote: true, id: '', class: 'btn'
    else
      content_tag(:div, class: 'btn-group dropup') do
        link_to(t('sales.payment').html_safe + content_tag(:span, nil, class: 'caret'), '#', class: 'btn dropdown-toggle', 'data-toggle' => 'dropdown') +
        content_tag(:ul, class: 'dropdown-menu') do
          content_tag(:li, link_to(t('payments.kinds.mixed'), sale_payments_path(sale_id: sale.id), remote: true)) +
          content_tag(:li, nil, class: 'divider') +
          content_tag(:li, link_to(t('payments.kinds.certificate'), new_sale_payment_path(sale_id: sale.id, payment: {kind: 'certificate', value: sale.calculation_amount}), remote: true)) +
          content_tag(:li, link_to(t('payments.kinds.credit'), new_sale_payment_path(sale_id: sale.id, payment: {kind: 'credit', value: sale.calculation_amount}), remote: true)) +
          content_tag(:li, link_to(t('payments.kinds.card'), new_sale_payment_path(sale_id: sale.id, payment: {kind: 'card', value: sale.calculation_amount}), remote: true)) +
          content_tag(:li, link_to(t('payments.kinds.cash'), sale_payments_path(sale_id: sale.id, payment: {kind: 'cash', value: sale.calculation_amount}), method: :post, remote: true, rel: 'nofollow'))
        end
      end
    end
  end

  def link_to_add_payment(append_to_selector, f)
    new_payment = Payment.new client_info: f.object.client_presentation
    fields = f.fields_for(:payments, new_payment, child_index: 'new_payments') do |builder|
      render('payments/payment_fields', f: builder, index: 'new_payments')
    end
    link_to glyph('plus') + t('payments.add').html_safe, '#', class: 'add_fields add_payment btn btn-success btn-small', data: { selector: append_to_selector, association: 'payments', content: (fields.gsub('\n', '')) }
  end

end