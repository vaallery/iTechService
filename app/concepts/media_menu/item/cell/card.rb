module MediaMenu
  module Item::Cell
    class Card < BaseCell
      self.translation_path = 'media_menu.item.view'

      private

      include ModelCell
      include ActiveSupport::NumberHelper

      property :name, :description, :image_file, :genre, :year

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

      def select_button(options = {})
        link_to t('.select'), '#', options
      end
    end
  end
end