module Service
  module JobTemplate::Cell
    class Form < BaseCell
      self.translation_path = 'service/job_template'
      private

      include FormCell
      include ActionView::Helpers::FormOptionsHelper

      def field_names_for_select
        JobTemplate::FIELD_NAMES.map do |field_name|
          [ServiceJob.human_attribute_name(field_name), field_name]
        end
      end

      def header_tag
        content_tag :div, class: 'page-header' do
          content_tag :h2, "#{link_to_index} #{content_tag(:span, '/', class: 'muted')} #{page_title}"
        end
      end

      def page_title
        action_name = model.persisted? ? 'edit' : 'new'
        t "service/job_template.form.title.#{action_name}"
      end

      def link_to_index
        link_to t('service/job_template.index.title'), service_job_templates_path
      end
    end
  end
end
