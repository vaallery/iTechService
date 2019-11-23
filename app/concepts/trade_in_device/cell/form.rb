module TradeInDevice::Cell
  class Form < BaseCell
    self.translation_path = 'trade_in_device'

    private

    include FormCell
    include ActionView::Helpers::FormOptionsHelper
    include ActionView::Helpers::DateHelper

    def header_tag
      content_tag :div, class: 'page-header' do
        content_tag :h2, "#{link_to_index} #{content_tag(:span, '/', class: 'muted')} #{page_title}"
      end
    end

    def page_title
      action_name = model.persisted? ? 'edit' : 'new'
      t ".form.title.#{action_name}"
    end

    def link_to_index
      link_to t('.index.title'), trade_in_devices_path
    end

    def able_to_manage_trade_in?
      current_user.able_to?(:manage_trade_in)
    end

    def persisted?
      model.persisted?
    end

    def replacement_statuses
      TradeInDevice.replacement_statuses.map do |name, _|
        [TradeInDevice.human_attribute_name("replacement_status/#{name}"), name]
      end
    end

    def departments
      Department.select(:id, :name).selectable.map { |department| [department.name, department.id] }
    end
  end
end
