module Service
  module FreeTask::Cell
    class Preview < BaseCell
      private

      include ModelCell
      property :id, :name, :code

      def link_to_edit
        link_to icon(:edit), edit_service_free_task_path(id), class: 'btn btn-small'
      end

      def link_to_destroy
        link_to icon(:trash), model, method: 'delete', data: {confirm: t('helpers.links.confirm', default: 'Are you sure?')}, class: 'btn btn-danger btn-small'
      end
    end
  end
end
