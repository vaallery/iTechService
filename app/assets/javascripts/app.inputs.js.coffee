App.DeviceInput =

  check_imei: ->
    $input = $('.device_input')
    item_id = $input.find('.item_id').val()

    $.getJSON '/service_jobs/check_imei?item_id='+item_id, (data)->
      if data.present
        $input.parents('.control-group').addClass 'warning'
        if $input.siblings('.help-inline').length
          $input.siblings('.help-inline').html data.msg
        else
          $input.parents('.controls').append "<span class='help-inline'>"+data.msg+"</span>"
      else
        $input.parents('.control-group').removeClass 'warning'
        $input.siblings('.help-inline').remove()

#== Item Input ==================================

App.initDeviceInput = ->
  $('.device_input>.item_search').autocomplete
    source: '/devices/autocomplete.json'
    focus: (event, ui)->
      $(this).val(ui.item.label)
      false
    select: (event, ui)->
      $(this).val(ui.item.label)
      $(this).siblings('.item_id').val(ui.item.value)
      $(this).siblings('.edit_item_btn').attr('href', "/devices/#{ui.item.value}/edit.js").attr('data-remote', true)
      App.DeviceInput.check_imei()
      false

App.bindTextAreasEvents = ->
  $(document).on 'focus', 'textarea', ->
    $('textarea.focus').removeClass('focus')
    $(this).addClass('focus')

jQuery ->
  App.initDeviceInput()
  App.bindTextAreasEvents()