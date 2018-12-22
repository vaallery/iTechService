class TradeInDevice::Contract < BaseContract
  model TradeInDevice
  properties :item, writeable: false

  properties :item_id, :appraised_value, :bought_device, :client_name, :client_phone, :check_icloud, :appraiser,
             :received_at, :replacement_status, :archived, :archiving_comment, :condition, :equipment,
             :apple_guarantee

  validates :received_at, :item_id, :appraised_value, :appraiser, :bought_device,
            :client_name, :client_phone, :check_icloud, presence: true
end
