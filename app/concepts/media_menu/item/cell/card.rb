module MediaMenu
  module Item::Cell
    class Card < BaseCell
      self.translation_path = 'media_menu.item.view'

      private

      include ModelCell
      include ActiveSupport::NumberHelper

      property :id, :name, :description, :image_file, :genre, :year

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
        number_to_human_size model.size
      end

      def selection_buttons
        %w[select remove].map do |action|
          button_tag t(".#{action}"), type: 'button', class: "selection_button #{action} #{selection_button_class}",
                     'data-behaviour': "#{action}-media_menu-item", onclick: "MediaMenu.#{action}_item(#{id})"
        end.join
      end

      def selection_button_class
        'btn btn-outline-primary btn-block card-link'.freeze
      end
    end
  end
end