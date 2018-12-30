module TradeInDevice::Cell
  class Form < BaseCell
    self.translation_path = 'trade_in_device'

    def show
      if superadmin?
        render 'superadmin_form'
      else
        render 'form'
      end
    end

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

    def superadmin?
      current_user.superadmin?
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
