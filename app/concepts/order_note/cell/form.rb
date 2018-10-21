module OrderNote::Cell
  class Form < BaseCell
    private

    include FormCell

    alias order_note model

    def contract
      [order_note.order, order_note]
    end

    def submit_label
      I18n.t 'order_notes.form.submit'
    end
  end
end
