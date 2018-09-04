module Service
  class RepairReturnContract < AContract
    required(:service_job_id).filled(:int?)
  end
end
