module FavoriteLinksHelper

  def navbar_favorite_links
    current_user.favorite_links.map do |favorite_link|
      menu_item favorite_link.name, favorite_link.url, target: '_blank'
    end.join.html_safe
  end
end