ProductCategory::KINDS.each do |kind|
  product_category = ProductCategory.find_or_create_by_kind(kind: kind, name: I18n.t("product_categories.kinds.#{kind}"))
  product_category.product_groups.find_or_create_by_name(name: I18n.t("product_categories.kinds.#{kind}"))
end