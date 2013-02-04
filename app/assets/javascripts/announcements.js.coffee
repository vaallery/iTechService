jQuery ->

  $('#coffer_order_link').popover()

  $(document).on 'click', '.close_announcement_button', ->
    $(this).parent().hide()
