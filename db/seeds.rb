# Department.where(code: ENV['DEPARTMENT_CODE']).first_or_create!(name: ENV['DEPARTMENT_NAME'], role: ENV['DEPARTMENT_ROLE'], address: '-', city: '-', contact_phone: '-', schedule: '-', url: '-')
# puts 'Departments'

# User.where(username: ENV['ADMIN_USERNAME']).first_or_create!(role: 'superadmin', password: ENV['ADMIN_PASSWORD'], password_confirmation: ENV['ADMIN_PASSWORD'], department_id: Department.current.id, email: ENV['ADMIN_EMAIL'])
# puts 'Admin'

#ProductCategory::KINDS.each do |kind|
#  product_category = ProductCategory.find_or_create_by_kind(kind: kind, name: I18n.t("product_categories.kinds.#{kind}"))
#  product_category.product_groups.find_or_create_by_name(name: I18n.t("product_categories.kinds.#{kind}"))
#end
# puts 'PRODUCT CATEGORIES'

# Settings
# Setting::DEFAULT_SETTINGS.each_pair do |name, value_type|
#   Department.all.each do |department|
#     Setting.where(department_id: department.id, name: name.to_s).first_or_create!(value_type: value_type, presentation: I18n.t("settings.#{name}", default: name.to_s.humanize))
#   end
# end
# puts 'DEFAULT SETTINGS'
