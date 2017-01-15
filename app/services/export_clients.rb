require 'vpim/vcard'

class ExportClients

  def call
    generate_vcard
  end

  def self.call
    new.call
  end

  private

  def generate_vcard
    file = File.open File.join(Rails.root, 'tmp', 'clients.vcf'), 'w'
    Client.find_each do |client|
      card = Vpim::Vcard::Maker.make2 do |maker|
        maker.add_name do |name|
          name.family = client.surname
          name.given = client.name
          name.additional = client.patronymic
        end
        maker.add_tel client.phone_number
      end
      file << card
    end
    file
  end

  class Client < ActiveRecord::Base
  end
end