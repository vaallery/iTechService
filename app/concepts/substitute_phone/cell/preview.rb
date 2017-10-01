module SubstitutePhone::Cell
  class Preview < BaseCell
    include ModelCell
    delegate :presentation, :name, :serial_number, :imei, to: :item

    def can_manage?
      policy(model).manage?
    end

    def html_class
      model.service_job.present? ? 'error' : 'success'
    end

    def department
      model.department.name unless model.department.nil?
    end

    def item
      @item ||= ItemDecorator.new(model.item)
    end
  end
end
