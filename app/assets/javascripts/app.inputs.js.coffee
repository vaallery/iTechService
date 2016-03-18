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
      false

jQuery ->
  App.initDeviceInput()