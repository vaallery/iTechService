after :feature_types do
  imei_id = FeatureType.imei.id
  sn_id = FeatureType.serial_number.id

  {
    'Девайс' => {kind: 'equipment', feature_type_ids: [sn_id]},
    'Девайс с SIM' => {kind: 'equipment', feature_type_ids: [sn_id, imei_id]},
    'Аксессуар' => {kind: 'accessory'},
    'Аксессуар с серийником' => {kind: 'accessory', feature_type_ids: [sn_id]},
    'Услуга' => {kind: 'service'},
    'Плёнка' => {kind: 'protector'},
    'Запчасть' => {kind: 'spare_part'},
  }.each do |name, params|
    ProductCategory.where(name: name).first_or_create! params
  end
end
