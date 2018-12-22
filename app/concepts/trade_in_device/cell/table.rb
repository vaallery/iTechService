module TradeInDevice::Cell
  class Table < BaseCell
    private

    include IndexCell
    include ActiveSupport::NumberHelper

    def trade_in_devices
      cell(Preview, collection: model).()
    end

    def total_count
      model.count
    end

    def total_value
      value = model.sum(:appraised_value)
      number_to_currency value
    end
  end
end
