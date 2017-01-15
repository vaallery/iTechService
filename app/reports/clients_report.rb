class ClientsReport < BaseReport

  def call
    result[:new_clients] = []
    new_clients = Client.where(created_at: period)
    new_clients.each do |client|
      client_devices = client.service_jobs.where(created_at: period).map{|service_job| {id: service_job.id, presentation: service_job.presentation}}
      result[:new_clients] << {id: client.id, presentation: client.presentation, created_at: client.created_at, service_jobs: client_devices}
    end
    result[:clients_count] = Client.count
    result[:new_clients_count] = new_clients.count
    result
  end
end