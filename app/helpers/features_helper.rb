module FeaturesHelper

  def features_presentation(object)
    if (features = object.try(:features)).present?
      features.map do |feature|
        "#{feature.name}: #{feature.value}"
      end.join(', ').html_safe
    else
      nil
    end
  end

end
