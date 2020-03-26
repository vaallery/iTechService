module Comment::Cell
  class Preview < BaseCell
    private

    property :user_color, :user_name, :content

    def timestamp
      "[#{I18n.l(model.created_at, format: :date_time)}]"
    end
  end
end
