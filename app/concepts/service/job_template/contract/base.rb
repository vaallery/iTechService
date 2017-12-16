module Service
  module JobTemplate::Contract
    class Base < BaseContract
      model 'service/job_template'
      properties :field_name, :content
      validates :content, presence: true
    end
  end
end