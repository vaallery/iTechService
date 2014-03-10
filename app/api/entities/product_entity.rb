class Entities::ProductEntity < Grape::Entity
  expose :id, :name
  expose :quantity do |product, options|
    product.quantity_in_store options[:store]
  end
end