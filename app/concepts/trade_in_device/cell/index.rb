module TradeInDevice::Cell
  class Index < BaseCell
    self.translation_path = 'trade_in_device.index'

    private

    include IndexCell

    def page_title
      index_title = t('.title')
      archive_title = t('.archive')

      if params.key? :archive
        index_item = link_to(index_title, trade_in_devices_path)
        archive_item = archive_title
      else
        index_item = index_title
        archive_item = link_to(archive_title, trade_in_devices_path(archive: true))
      end

      divider = content_tag(:span, '/', class: 'muted')
      "#{index_item} #{divider} #{archive_item}"
    end

    def new_link
      link_to icon('plus'), new_trade_in_device_path, class: 'btn btn-success btn-large'
    end

    def table
      if collection.any?
        cell(Table, collection).()
      else
        nothing_found_message
      end
    end
  end
end