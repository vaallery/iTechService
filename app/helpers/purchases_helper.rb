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

  def link_to_new_revaluation_act(purchase)
    title = content_tag(:div) do
      content_tag(:span, t('purchases.choose_products')) + ' ' + link_to(t('done'), new_revaluation_act_path(revaluation_act: {product_ids: '[]'}), class: 'btn btn-small btn-primary pull-right', id: 'new_revaluation_act_link')
    end
    content = content_tag(:table, class: 'table table-condensed', id: 'products_to_revaluate') do
      content_tag(:tbody) do
        purchase.batches.map do |batch|
          content_tag(:tr) do
            content_tag(:td, content_tag(:label, check_box_tag("product_#{batch.product.id}", 1, false, product_id: batch.product.id) + batch.name, class: 'checkbox'))
          end
        end.join.html_safe
      end
    end
    link_to(t('purchases.new_revaluation_act'), '#', class: 'btn btn-success has-popover', data: {html: true, placement: 'top', title: title.gsub('\n', ''), content: content.gsub('\n', '')})
  end

  def link_to_print_barcodes(purchase)
    content = form_tag(print_barcodes_purchase_path(purchase), method: :put) do |f|
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
