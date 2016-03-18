{
  'Связь' => {
    code: 'connectivity',
    position: 1,
    values: %w[Wi-Fi\ +\ Cellular Wi-Fi]
  },
  'Дисплей' => {
    code: 'display',
    position: 2,
    values: %w[27" 21,5" 17" 15" 13" 11"]
  },
  'Цвет' => {
    code: 'color',
    position: 3,
    values: %w[Gold Rose\ Gold Space\ Gray Silver Pink Yellow Blue Red Purple Green Black White]
  },
  'Ёмкость' => {
    code: 'capacity',
    position: 4,
    values: %w[512GB 256GB 128GB 64GB 32GB 16GB ?]
  }
}.each do |name, params|
  option_type = OptionType.where(name: name).first_or_create!(code: params[:code], position: params[:position])
  params[:values].each do |value_name|
    option_type.option_values.where(name: value_name).first_or_create!(code: (value_name == '?' ? value_name : value_name.parameterize))
  end
end
