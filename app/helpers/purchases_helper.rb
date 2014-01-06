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

end
