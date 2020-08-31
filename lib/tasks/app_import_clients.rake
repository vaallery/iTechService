# namespace :app do
#   desc "Import clients"
#   task import_clients: :environment do
#     DEPARTMENTS = {vl: 2, kh: 1, sakh: 4}
#     DEPARTMENT_CODE = :sakh
#
#     class ImpClient < ActiveRecord::Base
#       establish_connection adapter: 'postgresql', database: "itechservice_#{DEPARTMENT_CODE}"
#       self.table_name = 'clients'
#     end
#
#     class LocClient < ActiveRecord::Base
#       establish_connection adapter: 'postgresql', database: 'itechservice_vl'
#       self.table_name = 'clients'
#     end
#
#     start_time = Time.current
#     log = Logger.new("log/import_clients-#{DEPARTMENT_CODE}-#{start_time.strftime('%H-%M-%S')}.log")
#     log.info "=== Task started at #{start_time} ==="
#     log.info "Clients to import: #{ImpClient.count}"
#     imported_count = 0
#     department_id = DEPARTMENTS[DEPARTMENT_CODE]
#
#     ImpClient.find_each do |imp_client|
#       attributes = imp_client.attributes.except(*%w[id department_id client_characteristic_id])
#
#       if LocClient.exists? full_phone_number: attributes['full_phone_number']
#         log.warn "- Client exists #{attributes.slice(*%w[full_phone_number surname name]).values.join(' ')}"
#       else
#         client = LocClient.new attributes
#         client.department_id = department_id
#         client.save!
#         imported_count += 1
#       end
#     end
#
#     log.info "=== Clients imported: #{imported_count}"
#     log.close
#   end
# end