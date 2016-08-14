module PurchasesHelper

  def purchase_row_class(purchase)
    case purchase.status
      when 0 then 'info'
      when 1 then 'success'
      when 2 then 'error'
    end
  end

  def purchase_status(purchase)
    t "purchases.statuses.#{purchase.status_s}"
  end

  def link_to_print_barcodes(purchase)
    content = form_tag(print_barcodes_purchase_path(purchase), method: :patch) do |f|
      content_tag(:label, class: 'checkbox') do
        check_box_tag('with_price') +
        t('purchases.print_barcodes.with_price')
      end +
      content_tag(:label, class: 'checkbox') do
        check_box_tag('by_qty') +
        t('purchases.print_barcodes.by_qty')
      end +
      submit_tag(t('purchases.print_barcodes.submit'), class: 'btn btn-primary')
    end.html_safe.gsub('\n','')
    link_to t('purchases.show.print_barcodes'), '#', class: 'btn has-popover', data: {html: true, placement: 'top', title: t('purchases.show.print_barcodes'), content: content}
  end

end
