module SalesHelper

  def options_for_sale_kind_select(kind=false)
    options_for_select %w[sale return return_check].map { |k| [t("sales.kinds.#{k}"), k] }, kind
  end

  def link_to_post_sale(sale)
    if sale.new_record?
      link_to t('sales.close_check'), '#', id: 'sale_close_check', class: 'btn', disabled: true
    else
      link_to t('sales.close_check'), post_sale_path(@sale), method: 'put', id: 'sale_close_check', class: 'btn', data: {confirm: t('confirmation')}
    end
  end

end
