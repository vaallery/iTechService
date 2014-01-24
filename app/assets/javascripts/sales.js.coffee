jQuery ->

  $(document).on 'change', '#sale_items .sale_item_discount, #sale_items .quantity>input', ->
    $row = $(this).closest('tr.sale_item_fields')
    calculate_sale_item_row $row
    calculate_sale_items_total_sum()

  if $('#sale_items').length > 0
    $(document).on 'click', '.remove_fields', ->
      calculate_sale_items_total_sum()

  $(document).on 'click', '#sale_scan_barcode', ->
    scanProductBarcode()

  $(document).on 'click', '#sale_enter_barcode', ->
    enterProductBarcode()

scanProductBarcode = ->
  scaned_code = ''
  $('#barcode_reader').fadeIn().addClass('in')
  $(document).on 'keydown', (event)->
    if $('#barcode_reader:visible').length > 0
      console.log event.keyCode
      if event.keyCode is 13 and scaned_code isnt ''
        $('#barcode_reader').removeClass('in').fadeOut()
        $.get '/items.js?form=sale&association=sale_items&q='+scaned_code
      else
        if event.keyCode in [48..57]
          scaned_code = scaned_code[1..-1] if scaned_code.length is 12
          scaned_code += String.fromCharCode(event.keyCode)
  setTimeout (->
    closeBarcodeReader()
  ), 5000

window.enterProductBarcode = ->
  $('#barcode_reader #barcode_field').val('')
  $('#barcode_reader #barcode_reader_inner').show()
  $('#barcode_reader').fadeIn().addClass('in')
  $('#barcode_reader #barcode_field').on 'keydown', (event)->
    if event.keyCode is 13 and $('#barcode_reader #barcode_field').val() isnt ''
      $('#barcode_reader').removeClass('in').fadeOut()
      $.get '/items.js?form=sale&association=sale_items&q='+$('#barcode_reader #barcode_field').val()

window.calculate_sale_items_total_sum = ->
  total_sum = 0
  $('#sale_items tr.sale_item_fields td.sum:visible').each ->
    total_sum += accounting.unformat $(this).text()
  discount_sum = 0

  $('#sale_result_value').text accounting.formatMoney(total_sum)
  $('#sale_sum_cell').text accounting.formatMoney(total_sum)
  $('#sale_discount_cell').text accounting.formatMoney(discount_sum)
  $('#sale_discounted_sum').text accounting.formatMoney(total_sum - discount_sum)

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
