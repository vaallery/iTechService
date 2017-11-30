module MediaMenu::Cell
  class Layout < BaseCell
    private

    include ActionView::Helpers::CsrfHelper

    def title
      t '.title', default: 'Media menu'
    end
  end
end
