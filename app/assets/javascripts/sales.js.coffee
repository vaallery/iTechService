jQuery ->

  $(document).on 'click', '.add_fields, .remove_fields', ->
    enumerate_table('#sale_products')

  if $('#sale_products').length > 0
    enumerate_table('#sale_products')

#  $(document).on 'change', '#sale_store_id', ->
