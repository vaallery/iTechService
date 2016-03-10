{
  'Связь' => {
    code: 'connectivity',
    position: 1,
    values: %w[Wi-Fi\ +\ Cellular Wi-Fi]
  },
  'Дисплей' => {
    code: 'display',
    position: 2,
    values: %w[27" 21" 15" 13" 11"]
  },
  'Цвет' => {
    code: 'color',
    position: 3,
    values: %w[Gold Space\ Gray Silver Pink Yellow Blue Red Purple Green]
  },
  'Ёмкость' => {
    code: 'capacity',
    position: 4,
    values: %w[256GB 128GB 64GB 32GB 16GB ?]
  }
}.each do |name, params|
  option_type = OptionType.where(name: name).first_or_create!(code: params[:code], position: params[:position])
  params[:values].each do |value_name|
    option_type.option_values.where(name: value_name).first_or_create!(code: (value_name == '?' ? value_name : value_name.parameterize))
  end
end
