puts 'PRODUCT CATEGORIES'
#ProductCategory::KINDS.each do |kind|
#  product_category = ProductCategory.find_or_create_by_kind(kind: kind, name: I18n.t("product_categories.kinds.#{kind}"))
#  product_category.product_groups.find_or_create_by_name(name: I18n.t("product_categories.kinds.#{kind}"))
#end

# Settings
puts 'DEFAULT SETTINGS'
Setting::DEFAULT_SETTINGS.each_pair do |key, value|
  Department.all.each do |department|
    Setting.where(department_id: department.id, name: key).first_or_create(value_type: value)
  end
end