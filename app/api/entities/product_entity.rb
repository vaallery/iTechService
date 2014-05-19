class Entities::ProductEntity < Grape::Entity
  expose :id, :name, :retail_price
  expose :product_group_id, if: lambda {|product, options| options[:show_group]}
  expose :quantity do |product, options|
    product.quantity_in_store options[:store]
  end
end