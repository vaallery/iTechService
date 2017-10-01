class BaseCell < Trailblazer::Cell
  include GlyphHelper
  # include FontAwesome::Sass::Rails::ViewHelpers
  # include Devise::Controllers::Helpers
  include ActionView::Helpers::TranslationHelper
  include Cell::Translation
  include LinksHelper

  delegate :view_context, :controller_name, :current_user, :policy, to: :controller

  alias_method :icon, :glyph
end
