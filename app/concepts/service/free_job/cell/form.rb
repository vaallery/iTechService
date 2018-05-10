module Service
  module FreeJob::Cell
    class Form < BaseCell
      private

      include FormCell
      include ClientsHelper

      def header_tag
        content_tag :div, class: 'page-header' do
          content_tag :h2, "#{link_to_index} #{content_tag(:span, '/', class: 'muted')} #{page_title}"
        end
      end

      def page_title
        action_name = model.persisted? ? 'edit' : 'new'
        t ".#{action_name}"
      end

      def link_to_index
        link_to t('.index'), service_free_jobs_path
      end

      def tasks
        options[:tasks]
      end
    end
  end
end
