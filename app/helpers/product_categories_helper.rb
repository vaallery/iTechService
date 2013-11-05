module ProductCategoriesHelper

  def product_category_kinds_for_select
    ProductCategory::KINDS.map {|kind| [t("product_categories.kinds.#{kind}"), kind]}
  end

  def human_product_category_kind(arg)
    t "product_categories.kinds.#{arg.is_a?(ProductCategory) ? arg.kind : arg}"
  end

end
