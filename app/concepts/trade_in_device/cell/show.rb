module TradeInDevice::Cell
  class Show < Preview
    private

    include FormHelper

    property :appraiser, :bought_device, :client_name, :client_phone, :check_icloud, :archiving_comment
    delegate :human_attribute_name, to: :TradeInDevice
    delegate :name, to: :decorated_item

    def attribute_presentation(attr_name)
      content_tag :tr do
        content_tag(:td, human_attribute_name(attr_name)) +
          content_tag(:td, send(attr_name))
      end
    end

    def item
      link_to name, device_path(model.item), remote: true
    end

    def archived
      TradeInDevice.human_attribute_name("archived/#{model.archived}")
    end

    def link_to_index
      link_to t('.index.title'), trade_in_devices_path
    end

    def link_to_print
      link_to t('helpers.links.print'), print_trade_in_device_path(id), target: '_blank', class: 'btn btn-default'
    end

    def link_to_edit
      link_to t('helpers.links.edit'), edit_trade_in_device_path(id), class: 'btn btn-default'
    end

    def link_to_destroy
      link_to t('helpers.links.destroy'), trade_in_device_path(id), method: 'delete', data: {confirm: t('helpers.links.confirm', default: 'Are you sure?')}, class: 'btn btn-danger'
    end
  end
end
