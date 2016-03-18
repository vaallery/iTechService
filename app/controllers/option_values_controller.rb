class OptionValuesController < ApplicationController
  # decorates_assigned :option_values
  # authorize_resource
  # respond_to :json
  #
  def index
    product_group = ProductGroup.find params[:product_type_id]
    @option_values = product_group.option_values.ordered

  end
end
