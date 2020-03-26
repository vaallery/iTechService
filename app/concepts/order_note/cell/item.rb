module OrderNote::Cell
  class Item < BaseCell
    private

    property :author_color, :author_name, :content

    def timestamp
      "[#{I18n.l(model.created_at, format: :date_time)}]"
    end
  end
end
