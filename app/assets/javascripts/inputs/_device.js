(function(){
  App.Inputs.Device = {
    check_imei: function() {
      const $input = $('.device_input')
      const item_id = $input.find('.item_id').val()
      $.getJSON("/items/" + item_id + "/check_status", function(data) {
        const $search_input = $input.find('.item_search')

        if (data.status_info.length > 0) {
          $search_input.attr('data-status', data.status)
          $search_input.tooltip('destroy')
          $search_input.attr('title', data.status_info)
          $search_input.tooltip()
        } else {
          $search_input.attr('data-status', '')
          $search_input.attr('title', '')
          $search_input.tooltip('destroy')
        }
      })
    }
  }

  $(function(){
    $('.device_input>.item_search').autocomplete({
      source: '/devices/autocomplete.json',
      focus: function(event, ui) {
        $(this).val(ui.item.label)
        return false
      },
      select: function(event, ui) {
        $(this).val(ui.item.label)
        $(this).siblings('.item_id').val(ui.item.value)
        $(this).siblings('.edit_item_btn').attr('href', "/devices/" + ui.item.value + "/edit.js").attr('data-remote', true)
        $(this).siblings('.show_item_btn').attr('href', "/devices/" + ui.item.value + ".js").attr('data-remote', true)
        App.Inputs.Device.check_imei()
        return false
      }
    })
  })
}).call(this)
