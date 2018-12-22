module Comment::Cell
  class Form < BaseCell
    private

    include FormCell

    alias comment model
  end
end
