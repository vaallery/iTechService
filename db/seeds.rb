puts 'PRODUCT CATEGORIES'
#ProductCategory::KINDS.each do |kind|
#  product_category = ProductCategory.find_or_create_by_kind(kind: kind, name: I18n.t("product_categories.kinds.#{kind}"))
#  product_category.product_groups.find_or_create_by_name(name: I18n.t("product_categories.kinds.#{kind}"))
#end

# Departments
Department.where(code: 'vl').first_or_create(name: 'Владивосток', role: 0, city: 'Владивосток', address: '-', contact_phone: '-', schedule: '-', url: '-')

# Settings
puts 'DEFAULT SETTINGS'
Setting::DEFAULT_SETTINGS.each_pair do |key, value|
  Department.all.each do |department|
    Setting.where(department_id: department.id, name: key).first_or_create(value_type: value)
  end
  Setting.where(department_id: nil, name: key).first_or_create(value_type: value)
end