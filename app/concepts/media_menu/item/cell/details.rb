module MediaMenu
  module Item::Cell
    class Details < Card
      private

      property :description

      def image
        image_tag image_file, width: 176
      end

      def year
        "#{t_attribute(:year)}: #{model.year}"
      end

      def genre
        "#{t_attribute(:genre)}: #{model.genre}"
      end

      def category
        "#{t_attribute(:category)}: #{model.category}"
      end
    end
  end
end