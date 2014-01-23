module SalesHelper

  def options_for_sale_kind_select
    options_for_select %w[sale return return_check].map { |kind| [t("sales.kinds.#{kind}"), kind] }, 'sale'
  end

end
