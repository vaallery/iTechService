module Service
  module JobTemplate::Cell
    class Preview < BaseCell
      private

      include ModelCell
      property :id, :content

      def field_name
        return nil unless JobTemplate::FIELD_NAMES.include?(model.field_name)
        ServiceJob.human_attribute_name model.field_name
      end

      def link_to_edit
        link_to icon(:edit), edit_service_job_template_path(id), class: 'btn btn-small'
      end

      def link_to_destroy
        link_to icon(:trash), model, method: 'delete', data: {confirm: t('helpers.links.confirm', default: 'Are you sure?')}, class: 'btn btn-danger btn-small'
      end
    end
  end
end
