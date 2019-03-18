App.DeviceInput =

  check_imei: ->
    $input = $('.device_input')
    item_id = $input.find('.item_id').val()

    $.getJSON "/items/#{item_id}/check_status", (data)->
      $search_input = $input.find('.item_search')

      if (data.status_info.length > 0)
        $search_input.attr('data-status', data.status)
        $search_input.tooltip('destroy')
        $search_input.attr('title', data.status_info)
        $search_input.tooltip()
      else
        $search_input.attr('data-status', '')
        $search_input.attr('title', '')
        $search_input.tooltip('destroy')

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
      $(this).siblings('.show_item_btn').attr('href', "/devices/#{ui.item.value}.js").attr('data-remote', true)
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

App.init_data_storage_input = ->
  $(document).on 'change', '.data_storage-checkbox', (event)->
    $input = $(this).closest('.data_storage-input')

    $checkboxes = $input.find('.data_storage-checkbox:checked')
    checked_storages = $checkboxes.map (checkbox)->
      $(this).siblings('.data_storage-label').text()

    checked_storages = $.makeArray(checked_storages).join(', ')
    $input.find('.input-presentation').html(checked_storages || '-')

    $input.find('.dropdown-toggle').dropdown('toggle')

jQuery ->
  App.initDeviceInput()
  App.bindTextAreasEvents()
  App.init_dropdown_input()
  App.init_data_storage_input()
  App.init_client_input()