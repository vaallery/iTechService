jQuery ->

  $(document).on 'click', '#movement_act_form .add_fields, #movement_act_form .remove_fields', ->
    enumerate_table('#movement_items')

  if $('#movement_items').length > 0
    enumerate_table('#movement_items')

  $('#movement_act_store_id').change ->
    store_id = $(this).val()
    $('#movement_items tr.movement_item_fields td.available_quantity').each ->
      $cell = $(this)
      item_id = $('input.item_id', $cell.siblings('td.product')).val()
      unless store_id is undefined or item_id is undefined
        $.getJSON "/items/#{item_id}/remains_in_store?store_id=#{store_id}", (data)->
          $cell.text data.quantity