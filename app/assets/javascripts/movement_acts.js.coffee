jQuery ->

  $(document).on 'click', '#movement_act_form .add_fields, #movement_act_form .remove_fields', ->
    enumerate_table('#movement_items')

  if $('#movement_items').length > 0
    enumerate_table('#movement_items')