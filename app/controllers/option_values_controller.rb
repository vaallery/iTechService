class OptionValuesController < ApplicationController
  def index
    authorize OptionValue
    product_group = ProductGroup.find(params[:product_type_id])
    @option_values = product_group.option_values.ordered
  end
end
