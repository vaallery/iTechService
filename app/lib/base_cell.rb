class BaseCell < Trailblazer::Cell
  private

  include GlyphHelper
  # include FontAwesome::Sass::Rails::ViewHelpers
  # include Devise::Controllers::Helpers
  include ActionView::Helpers::TranslationHelper
  include Cell::Translation
  include LinksHelper

  delegate :view_context, :controller_name, :action_name, :params, :current_user, :policy, to: :controller

  alias_method :icon, :glyph

  def title
    t '.title'
  end

  def superadmin?
    current_user.superadmin?
  end
end
