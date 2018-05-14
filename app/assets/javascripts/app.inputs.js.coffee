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

#=== Dropdown Input ===
App.init_dropdown_input = ->
  $(document).on 'click', 'a.dropdown-input-item', (event)->
    $this = $(this)
    $input = $this.closest('.dropdown-input')
    $input.find('.input-presentation').html($this.html())
    $input.find('.input-value').val($this.data('value'))
    event.preventDefault()

App.init_client_input = ->
  $(document).on 'click', '#client_input #client_transfer_link', (event)->
    $link = $(this)
    client_search = $link.siblings('#client_search').val()
    client_id = $link.siblings('.client_id').val()
    base_href = $link.attr('href').split('?')[0]
    param = if client_id.length > 0 then "service_job[client_id]=#{client_id}" else "client=#{client_search}"
    $link.attr('href', "#{base_href}?#{param}")

  $(document).on 'change', '#client_input #client_search', (event)->
    $(this).siblings('.client_id').val('')

jQuery ->
  App.initDeviceInput()
  App.bindTextAreasEvents()
  App.init_dropdown_input()
  App.init_client_input()