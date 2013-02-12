jQuery ->

  $('a', '#object_kinds_list').click (event)->
    $('#object_kind_value').text $(this).text()
    $('#order_object_kind').val $(this).attr('object_kind')
    event.preventDefault()

  $('a', '#statuses_list').click (event)->
    $('#status_value').text $(this).text()
    $('#order_status').val $(this).attr('status')
    event.preventDefault()

  $('#order_customer_type_user').click ->
    $('#order_form .control-group.client').addClass('hidden')
    $('#order_customer_id').val($('#profile_link').data('id'))

  $('#order_customer_type_client').click ->
    $('#order_form .control-group.client').removeClass('hidden')
    $('#order_customer_id').val('')
    $('#client_search').val('')
    $('#edit_client_link').attr('href','')
