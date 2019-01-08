module TradeInDevice::Cell
  class Purgatory < BaseCell
    private

    include IndexCell

    def page_title
      t('trade_in_device.purgatory')
    end

    def table
      cell(Table, collection).()
    end
  end
end
