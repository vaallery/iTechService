module PricesHelper

  def link_to_price price
    link_to price.file_name, price.file_url, target: '_blank'
  end

  def header_link_to_edit_prices
    content_tag(:li, class: nav_state_for('prices')) do
      link_to t('prices.link', default: 'Prices'), prices_path
    end.html_safe
  end

  def header_link_to_view_prices
    drop_down t('prices.link', default: 'Prices') do
      Price.all.map do |price|
        menu_item price.file_name, price.file_url
      end.join.html_safe
    end
  end

end
