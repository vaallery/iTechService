module MediaMenu
  module Cell
    class Catalog < BaseCell
      # self.view_paths << ['app/views']

      private

      include ModelCell
      include IconHelper
      include IndexCell
      include Kaminari::Cells

      def result
        options[:result]
      end

      def title
        t '.title', default: 'Media menu'
      end

      def search_placeholder
        t '.search'
      end

      def pagination
        paginate collection
      end

      def link_to_sort_by_name
        dir_icon = ''
        link_to "#{t_attribute(:name)} #{dir_icon}", '#', class: 'nav-link'
      end

      def link_to_sort_by(attribute)
        cur_dir = params.fetch('sort_dir', 'asc')
        dir_icon = params['sort_by'] == attribute ? sort_direction_icon(cur_dir) : ''
        dir = cur_dir == 'asc' ? 'desc' : 'asc'
        url = url_for sort_by: attribute, sort_dir: dir
        link_to "#{t_attribute(attribute)} #{dir_icon}", url, class: 'nav-link'
      end

      def sort_direction_icon(direction)
        direction == 'asc' ? '&uarr;' : '&darr;'
      end

      def category
        category_name = t(".category/#{result['category'] ||'all'}")
        "#{t('.category')}: #{category_name}"
      end

      def category_filter_links
        %w[all h n r c].map do |category|
          link_to t(".category/#{category}"), url_for(category: category), class: 'dropdown-item'
        end.join
      end

      def year_links
        ['1990', '1991', '1993'].each do |year|
          link_to year, '#', class: 'dropdown-item'
        end.join.html_safe
      end

      def content
        content_tag :div, item_cards, class: 'd-flex flex-wrap'
      end

      def item_cards
        cell(Item::Cell::Card, collection: model).()
      end
    end
  end
end
