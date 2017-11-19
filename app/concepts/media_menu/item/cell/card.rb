module MediaMenu
  module Item::Cell
    class Card < BaseCell
      self.translation_path = 'media_menu.item.view'

      private

      include ModelCell
      include ActiveSupport::NumberHelper

      property :id, :name, :description, :image_file, :genre, :year, :cart_item

      private

      def name_link
        link_to name, model, remote: true
      end

      def image_link
        link_to model, remote: true do
          image_tag image_file, width: 176, class: 'card-img-top'
        end
      end

      def size
        # value = number_to_human_size model.size
        # t '.size', value: value
        number_to_human_size model.size
      end

      def selection_button(options = {})
        if cart_item.nil?
          name = t('.select')
          url = media_menu_cart_items_path
          options[:params] = {item_id: id}
        else
          name = t('.remove')
          url = media_menu_cart_item_path(cart_item.id)
          options[:method] = :delete
        end
        options[:class] = selection_button_class
        options[:remote] = true
        button_to name, url, options
      end

      def selection_button_class
        'btn btn-outline-primary btn-block card-link'.freeze
      end
    end
  end
end