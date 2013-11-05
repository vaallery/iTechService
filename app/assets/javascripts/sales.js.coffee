jQuery ->

  if $('#sale_items').length > 0
    enumerate_table('#sale_items')

  $(document).on 'click', '.add_fields, .remove_fields', ->
    enumerate_table('#sale_items')

  $(document).on 'change', '.sale_item_discount', ->
    $row = $(this).closest('tr.sale_item_fields')
    calculate_sale_item_row $row
    calculate_sale_items_total_sum()

#  $(document).on 'change', '#sale_store_id', ->

window.calculate_sale_items_total_sum = ->
  total_sum = 0
  $('#sale_items tr.sale_item_fields td.sum').each ->
    total_sum += Number $(this).text()
  $('#sale_items td.total_sum').text total_sum

window.calculate_sale_item_row = (row)->
  $row = $(row)
  qty = Number $('td.quantity input', $row).val()
  price = Number $('td.price', $row).text()
  cur_discount = Number $('.sale_item_discount', $row).val()
  max_discount = Number $('.sale_item_discount', $row).attr('max')
  discount = if cur_discount > max_discount then max_discount else Number(cur_discount)
  sum = qty * (price - discount)
  $('.sale_item_discount', $row).val discount
  $('td.sum', $row).text(sum)
  return $('td.sum', $row).text()
