jQuery ->

  $device_form = $('form.device_form')

  $('.device_comment_tooltip').tooltip()

  $('.device_progress').tooltip
    placement: 'left'
    html: true

  if $device_form.length > 0

    $(document).on 'click', (event)->
      if $(this).parents('#clients_autocomplete_list').length is 0
        $('#clients_autocomplete_list').hide()

    $('.device_task_task').live 'change', () ->
      task_id = $(this).val()
      task_cost = $(this).parents('.device_task').find('.device_task_cost')
      $.getJSON '/tasks/'+task_id+'.json', (data) ->
        task_cost.val data.cost

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

    $('#questionnaire_link').live 'click', (event)->
      $this = $ this
      params = $this.parents('form:first').serialize()
      event.currentTarget.href = '/clients/questionnaire?' + params

    $('#client_devices_resize_button').click ->
      $('.client_devices_list').slideToggle(100)

    placeClientDevices()

  $('#print_device_ticket').click (event)->
    event.preventDefault()
#    win2 = window.open()
#    win2.location.assign('http://localhost:3000/devices/2009.pdf?part=2')
#    win1 = window.open()
#    win1.location.assign('http://localhost:3000/devices/2009.pdf?part=1')
    $('#print_device_ticket2')[0].click()
    setTimeout (->
      $('#print_device_ticket1')[0].click()
    ), 100

  $('#new_device_popup').mouseleave ->
    setTimeout (->
      $('#new_device_popup').fadeOut()
    ), 1000

placeClientDevices = ()->
  $devices = $('#client_devices')
  $input = $('#client_input')
  $('#client_devices').css
    top: $input.offset().top - 6
    left: $input.offset().left + $input.outerWidth()
  if $('.client_devices_list', $devices).length > 0
    $devices.show()
  else
    $devices.hide()

PrivatePub.subscribe '/devices/new', (data, channel)->
  if data.device.location_id == $('#profile_link').data('location')
    $('#new_device_popup').fadeIn()
