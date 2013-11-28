jQuery ->

  $(document).on 'change', '#sale_items .sale_item_discount, #sale_items .quantity>input', ->
    $row = $(this).closest('tr.sale_item_fields')
    calculate_sale_item_row $row
    calculate_sale_items_total_sum()

  if $('#sale_items').length > 0
    $(document).on 'click', '.remove_fields', ->
      calculate_sale_items_total_sum()

window.calculate_sale_items_total_sum = ->
  total_sum = 0
  $('#sale_items tr.sale_item_fields td.sum:visible').each ->
    total_sum += accounting.unformat $(this).text()
  $('#sale_items td.total_sum').text accounting.formatMoney(total_sum)

window.calculate_sale_item_row = (row)->
  $row = $(row)
  qty = Number $('td.quantity input', $row).val()
  price = accounting.unformat $('td.price', $row).text()
  cur_discount = Number $('.sale_item_discount', $row).val()
  max_discount = Number $('.sale_item_discount', $row).attr('max')
  discount = if cur_discount > max_discount then max_discount else Number(cur_discount)
  sum = qty * (price - discount)
  $('.sale_item_discount', $row).val discount
  $('td.sum', $row).text accounting.formatMoney(sum)
  return $('td.sum', $row).text()
