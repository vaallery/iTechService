module Service
  class RepairReturn::Build < ATransaction
    map :find_job
    map :build

    private

    def find_job(ticket_number: nil, service_job_id: nil, **)
      job = nil
      job = ServiceJob.find_by(id: service_job_id) if service_job_id.present?
      job ||= ServiceJob.find_by(ticket_number: ticket_number) if ticket_number.present?
      job
    end

    def build(job)
      RepairReturn.new service_job: job
    end
  end
end
