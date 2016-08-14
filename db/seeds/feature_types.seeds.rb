FeatureType.kinds.each do |kind|
  FeatureType.where(kind: kind).first_or_create!(name: FeatureType.human_attribute_name("kind.#{kind}"))
end
