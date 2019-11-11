module TradeInDevice::Cell
  class Preview < BaseCell
    self.translation_path = 'trade_in_device'
    private

    include ModelCell
    include ActiveSupport::NumberHelper

    property :id, :number, :condition, :equipment, :imei, :serial_number

    def item
      decorated_item.name
    end

    def clipped_condition
      condition&.length > 20 ? "#{condition[0..20]}..." : condition
    end

    def clipped_equipment
      equipment&.length > 20 ? "#{equipment[0..20]}..." : equipment
    end

    def decorated_item
      @item ||= ItemDecorator.new(model.item)
    end

    def appraised_value
      number_to_currency model.appraised_value
    end

    def replacement_status
      return '-' if model.replacement_status.nil?
      TradeInDevice.human_attribute_name("replacement_status/#{model.replacement_status}")
    end

    def apple_guarantee
      if model.apple_guarantee.present?
        l(model.apple_guarantee)
      elsif model.extended_guarantee?
        'Расширенная'
      else
        'Нет гарантии'
      end
    end

    def link_to_show
      link_to icon('eye-open'), trade_in_device_path(id), class: 'btn btn-small' if policy.show?
    end

    def link_to_edit
      link_to icon('edit'), edit_trade_in_device_path(id), class: 'btn btn-small' if policy.edit?
    end

    def link_to_destroy
      link_to icon('trash'), trade_in_device_path(id), method: 'delete', data: {confirm: t('helpers.links.confirm', default: 'Are you sure?')}, class: 'btn btn-danger btn-small' if policy.destroy?
    end

    def policy
      context[:policy]
    end
  end
end
