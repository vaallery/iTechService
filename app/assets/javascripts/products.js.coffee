jQuery ->

  $(document).on 'click', '.close_product_form', ->
    $('#product_form').html('')
    $('#product_form').slideUp()

  $(document).on 'click', '.product_selector .product_select_button', ->
    $(this).addClass('active')
    $(this).closest('.product_selector').addClass('active')

  search_timeout = null
  $(document).on 'keyup', '#product_choose_form #product_search_field', ->
    val = $(this).val()
    clearTimeout(search_timeout) if search_timeout?
    search_timeout = setTimeout (->
      $.get '/products.js', choose: true, product_q: val
    ), 250

  $(document).on 'keyup', '#product_choose_form #item_search_field', ->
    val = $(this).val()
    clearTimeout(search_timeout) if search_timeout?
    search_timeout = setTimeout (->
      $.get '/products/2/items.js', item_q: val
    ), 250

  $(document).on 'click', '#product_choose_form #clear_product_search_field', ->
    $('#product_choose_form #product_search_field').val('')
    $.get '/products.js', choose: true

  $(document).on 'click', '#product_choose_form .product_row', ->
    product_id = $(this).data('product')
    $.post '/products/select.js', product_id: product_id

  $(document).on 'click', '#product_choose_form .item_row', ->
    $('#product_choose_form #new_item_fields input').attr('disabled', true)
    $('#new_item_fields').hide()
    item_id = $(this).data('item')
    $.post '/products/select.js', item_id: item_id

  $(document).on 'click', '#product_choose_form #add_product_item', ->
    $('#product_choose_form #selected_item').attr('disabled', true).val('')
    $('#product_choose_form #new_item_fields input').removeAttr('disabled')
    $('#product_choose_form #new_item_fields').show()
    $(this).hide()

  validation_timeout = null
  $(document).on 'keyup', '#product_choose_form #new_item_fields input', ->
    clearTimeout(validation_timeout) if validation_timeout?
    validation_timeout = setTimeout (->
      is_valid = true
      $('#product_choose_form #new_item_fields input').each (i, input)->
        is_valid = false if input.value.trim() is ''
      if is_valid
        $('#product_choose_form #submit_product_button').removeAttr('disabled')
      else
        $('#product_choose_form #submit_product_button').attr('disabled', true)
    ), 250
