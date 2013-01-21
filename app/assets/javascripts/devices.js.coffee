jQuery ->
  
  $('.device_task_task').live 'change', () ->
    task_id = $(this).val()
    task_cost = $(this).parents('.device_task').find('.device_task_cost')
    $.getJSON '/tasks/'+task_id+'.json', (data) ->
      task_cost.val data.cost
      
  $('.device_comment_tooltip').tooltip()

  $('.device_progress').tooltip
    placement: 'left'
    html: true
  
  $('#history').live 'click', '.close_history', (event) ->
    $history = $('#history')
    $history.remove()
    event.preventDefault()

  $('a', '#locations_list').click (event) ->
    $('#location_value').text $(this).text()
    $('#device_location_id').val $(this).attr('location_id')
    event.preventDefault()

  $('#device_security_code_none').click (event)->
    $('#device_security_code').val '-'
    event.preventDefault()

  $('#client_search').keyup ()->
    $.getScript '/devices/autocomplete_client.js?client_q='+$(this).val()

  if $('#clients_autocomplete_list').length
    $('#clients_autocomplete_list').css
      left: $('#client_input').offset().left
      top: $('#client_input').offset().top + $('#client_input').outerHeight()

  $(document).on 'click', (event)->
    if $(this).parents('#clients_autocomplete_list').length is 0
      $('#clients_autocomplete_list').hide()

  $('#device_imei').blur ()->
    $.getJSON '/devices/check_imei?imei_q='+$(this).val(), (data)->
      if data.present
        $('#device_imei').parents('.control-group').addClass 'warning'
        if $('#device_imei').siblings('.help-inline').length
          $('#device_imei').siblings('.help-inline').html data.msg
        else
          $('#device_imei').parents('.controls').append "<span class='help-inline'>"+data.msg+"</span>"
      else
        $('#device_imei').parents('.control-group').removeClass 'warning'
        $('#device_imei').siblings('.help-inline').remove()
