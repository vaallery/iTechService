class BaseCell < Trailblazer::Cell
  include GlyphHelper
  # include FontAwesome::Sass::Rails::ViewHelpers
  # include Devise::Controllers::Helpers
  include ActionView::Helpers::TranslationHelper
  include Cell::Translation

  delegate :controller_name, :current_user, :policy, to: :controller

  alias_method :icon, :glyph

  def link_back_to_index(options = {})
    options.merge! action: 'index', controller: controller_name
    link_to icon('chevron-left'), url_for(options), class: 'link_back'
  end
end