module Service
  class RepairReturn::Create < ATransaction
    step :find_job
    step :validate
    step :prepare
    step :process

    private

    def find_job(service_job_id:, **params)
      service_job = ServiceJob.find_by id: service_job_id

      if service_job.present?
        Success params.merge(service_job: service_job)
      else
        Failure :job_not_found
      end
    end
    
    def validate(service_job:, **params)
      errors = []
      errors << 'not_archived' unless service_job.in_archive?
      errors << 'not_repair' unless service_job.repair_tasks.any?
      errors << 'already_returned' if RepairReturn.exists?(service_job_id: service_job.id)

      errors.any? ? Failure(errors) : Success(params.merge(service_job: service_job))
    end

    def prepare(service_job:, current_user:, **)
      repair_return = RepairReturn.new service_job: service_job, performer: current_user, performed_at: Time.current
      Success repair_return
    end

    def process(repair_return)
      errors = []

      RepairReturn.transaction do
        repair_return.repair_parts.each do |repair_part|
          store_item = repair_part.store_item(Department.current.spare_parts_store)
          store_item.add repair_part.quantity
        end

        sale_return = repair_return.sale.build_return

        unless sale_return.save and sale_return.post
          errors << sale_return.errors.full_messages
        end

        unless repair_return.save
          errors << repair_return.errors.full_messages
        end
      end

      errors.any? ? Failure(errors) : Success(repair_return)
    end
  end
end
