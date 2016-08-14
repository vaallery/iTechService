json.array! @items.decorate do |item|
  json.extract! item, :id, :product_id
  json.url item_url(item.id, format: :json)
  json.label item.presentation
  json.value item.id
end
