module PricesHelper

  def link_to_price price
    link_to price.file_name, price.file_url, target: '_blank'
  end

  def header_link_to_edit_prices
    content_tag(:li, class: nav_state_for('prices')) do
      link_to 'Prices', prices_path
    end.html_safe
  end

  def header_link_to_view_prices
    content_tag(:li, class: 'dropdown') do
      link_to(('Prices'+caret_tag).html_safe, '#', class: 'dropdown-toggle', 'data-toggle' => 'dropdown') +
      content_tag(:ul, class: 'dropdown-menu') do
        Price.all.map do |price|
          content_tag :li, link_to_price(price)
        end.join.html_safe
      end
    end.html_safe
  end

end
