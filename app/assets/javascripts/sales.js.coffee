jQuery ->

  if $('#sale_items').length > 0

    $(document).on 'click', '.remove_fields', ->
      calculateSaleItemsTotal()

    $(document).on 'click', '#sale_calculate', ->
      calculateSaleItemsTotal()

    $(document).on 'change', '#sale_items .sale_item_discount, #sale_items .quantity>input, #sale_items .price>input', ->
      $row = $(this).closest('tr.sale_item_fields')
      calculateSaleItemRow $row
      calculateSaleItemsTotal()

  $(document).on 'click', '#sale_scan_barcode', (event)->
    event.preventDefault()
    scanProductBarcode()

  $(document).on 'click', '#sale_enter_barcode', (event)->
    event.preventDefault()
    enterProductBarcode()

  $(document).on 'click', '#sale_enter_client_card', (event)->
    event.preventDefault()
    scanClientCard()

  $(document).on 'click', '#cancel_client_card_scan', (event)->
    event.preventDefault()
    closeClientCardReader()

  $(document).on 'click', '#sale_save_check', (event)->
    event.preventDefault()
    saveSale()

  $(document).on 'click', '#sale_copy_check', (event)->
    event.preventDefault()
    $.getScript '/sales?status=1&form_name=choose_form&act=copy'

  $(document).on 'change', '#sale_form #sale_kind', ->
    switch $(this).val()
      when 'return'
        $('#sale_form').removeClass('sale').addClass('return')
        $('#sale_form #sale_is_return').val('true')
      when 'sale'
        $('#sale_form').removeClass('return').addClass('sale')
        $('#sale_form #sale_is_return').val('false')
      when 'return_check'
        $.getScript '/sales?status=1&is_return=false&form_name=choose_form&act=return_check'
        $(this).val('return').change()

#  if $('#sale_top_panel').length > 0
#    $.getScript '/top_salables'

window.saveSale = ->
  $('#sale_form').submit()

window.scanProductBarcode = ->
  scaned_code = ''
  $('#barcode_reader').fadeIn().addClass('in')
  $(document).on 'keydown', (event)->
    if $('#barcode_reader:visible').length > 0
      console.log event.keyCode
      if event.keyCode is 13 and scaned_code isnt ''
        closeBarcodeReader()
        $.get '/items.js?form=sale&association=sale_items&q='+scaned_code
        scaned_code = ''
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
      closeBarcodeReader()
      $.get '/items.js?form=sale&association=sale_items&q='+$('#barcode_reader #barcode_field').val()

window.scanClientCard = ->
  $('#client_card_reader').fadeIn().addClass('in')
  card_number = ''
  $(document).on 'keydown', (event)->
    if $('#client_card_reader:visible').length > 0
      if event.keyCode is 13 and card_number isnt ''
        closeClientCardReader()
        $.get '/clients/'+card_number+'/find.js?form=sale'
        card_number = ''
      else
        card_number += String.fromCharCode(event.keyCode).toLowerCase()
  setTimeout (->
    closeClientCardReader()
  ), 5000

window.closeClientCardReader = ->
  $('#client_card_reader').removeClass('in').fadeOut()

window.calculateSaleItemsTotal = ->
  total_sum = 0
  total_discount = 0
#  $('#sale_items tr.sale_item_fields td.sum:visible').each ->
  $('#sale_items tr.sale_item_fields').each ->
    total_sum += accounting.unformat $('td.sum:visible', this).text()
    total_discount += Number $('.sale_item_discount', this).val()

  $('#sale_result_value').text accounting.formatMoney(total_sum - total_discount)
  $('#sale_sum_cell').text accounting.formatMoney(total_sum)
  $('#sale_discount_cell').text accounting.formatMoney(total_discount)
  $('#sale_discounted_sum_cell').text accounting.formatMoney(total_sum - total_discount)

window.calculateSaleItemRow = (row)->
  $row = $(row)
  qty = Number $('td.quantity input', $row).val()
  if $('td.price>input', $row).length > 0
    price = Number $('td.price>input', $row).val()
  else
    price = accounting.unformat $('td.price', $row).text()
  cur_discount = Number $('.sale_item_discount', $row).val()
  max_discount = Number $('.sale_item_discount', $row).attr('max')
  discount = if cur_discount > max_discount then max_discount else Number(cur_discount)
  sum = qty * (price - discount)
  $('.sale_item_discount', $row).val discount
  $('td.sum', $row).text accounting.formatMoney(sum)
  return $('td.sum', $row).text()
