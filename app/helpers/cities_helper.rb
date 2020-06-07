module CitiesHelper
  def city_tag(city)
    content_tag :span, city.name, class: 'city_tag', style: "background-color: #{city.color}"
  end
end
