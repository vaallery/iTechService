# after :product_categories do
#   {
#     'Девайс' => 'Техника',
#     'Аксессуар' => 'Аксессуары',
#     'Плёнка' => 'Плёнки',
#     'Услуга' => 'Услуги',
#     'Запчасть' => 'Запчасти'
#   }.each do |category_name, group_name|
#     if (product_category = ProductCategory.find_by_name(category_name)).present?
#       ProductGroup.where(name: group_name).first_or_create!(product_category_id: product_category.id)
#     end
#   end
#   product_group = ProductGroup.find_by_name('Техника')
#   {2 => 'iPhone 4', 5 => 'iPhone 4S', 1396 => 'iPhone 5', 2396 => 'iPhone 5C', 2395 => 'iPhone 5S', 3924 => 'iPhone 6', 3925 => 'iPhone 6 Plus', 26 => 'iPad 2', 800 => 'iPad 3', 2507 => 'iPad Air', 1570 => 'iPad mini', 2728 => 'iPad mini 2', 4113 => 'iPad mini 3', 4199 => 'iPad Air 2', 1524 => 'iPod nano 7th gen.', 44 => 'iPod shuffle', 1523 => 'iPod touch 5th gen.', 9 => 'iMac', 1922 => 'Mac mini', 11 => 'MacBook AIR', 10 => 'MacBook PRO', 1009 =>'Trade-in'}.each do |group_code, group_name|
#     product_category_id = group_name.start_with?('iPhone') ? ProductCategory.find_by_name('Девайс с SIM').id : product_group.product_category_id
#     product_group.children.where(name: group_name).first_or_create!(name: group_name, code: group_code, product_category_id: product_category_id)
#   end
#
#   product_group = ProductGroup.find_by_name('Запчасти')
#   {
#     'iPad' => %w[iPad \4 iPad\ Air iPad\ mini iPad\ mini\ 2 iPad\ 2 iPad\ 3],
#     'iPhone' => %w[iPhone\ 6 iPhone\ 6\ Plus iPhone\ 5S iPhone\ 5C iPhone\ 5 iPhone\ 4 iPhone\ 4S],
#     'MacBook' => %w[]
#   }.each do |group_name, sub_group_names|
#     new_product_group = product_group.children.where(name: group_name).first_or_create!(name: group_name, product_category_id: product_group.product_category_id)
#     sub_group_names.each do |sub_group_name|
#       new_product_group.children.where(name: sub_group_name).first_or_create!(name: sub_group_name, product_category_id: product_group.product_category_id)
#     end
#   end
# end
