module Service
  module FreeTask::Cell
    class Index < BaseCell
      private

      include IndexCell

      def free_tasks
        cell(Preview, collection: model).()
      end

      def title
        t '.index'
      end

      def new_link
        link_to icon(:plus), new_service_free_task_path, class: 'btn btn-success btn-large'
      end
    end
  end
end
