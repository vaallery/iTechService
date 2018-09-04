module Service
  class RepairReturn::Build < ATransaction
    map :find_job
    map :build

    private

    def find_job(ticket_number: nil, service_job_id: nil, **)
      service_job = nil
      service_job = ServiceJob.find_by(id: service_job_id) if service_job_id.present?
      service_job ||= ServiceJob.find_by(ticket_number: ticket_number) if ticket_number.present?
      service_job
    end

    def build(service_job)
      RepairReturn.new service_job: service_job
    end
  end
end
