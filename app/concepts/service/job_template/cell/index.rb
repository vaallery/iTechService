module Service
  module JobTemplate::Cell
    class Index < BaseCell
      self.translation_path = 'service/job_template.index'

      private

      include IndexCell

      def page_title
        t('service/job_template.index.title')
      end

      def job_templates
        cell(Preview, collection: model).()
      end

      def new_link
        link_to icon(:plus), new_service_job_template_path, class: 'btn btn-success btn-large'
      end
    end
  end
end
