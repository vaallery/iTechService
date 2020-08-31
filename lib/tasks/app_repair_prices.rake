require 'json'

namespace :app do
  desc "Dump prices"
  task dump_repair_prices: :environment do
    prices = {}
    RepairService.find_each do |service|
      prices.store service.id, service['price'].to_f
    end
    File.write 'prices.json', JSON.generate(prices)
  end

  desc "Import prices"
  task import_repair_prices: :environment do
    prices = JSON.parse(File.read('prices.json'))
    prices.each do |id, value|
      service = RepairService.find(id)
      service.prices.each do |price|
        price.update_column :value, value
      end
    end
  end
end
