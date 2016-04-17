require "test_helper"

class FavoriteLinkTest < ActiveSupport::TestCase
  def favorite_link
    @favorite_link ||= FavoriteLink.new
  end

  def test_valid
    assert favorite_link.valid?
  end
end
