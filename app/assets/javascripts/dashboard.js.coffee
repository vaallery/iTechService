
jQuery ->

  $('.device_tasks_toggle').click ->
    $(this).parents('.device_row').nextAll('.device_task_row.success').toggle()

#  $('.device_movement_column .history_link').click (event)->
#    $this = $(this)
##    $.getJSON()
#    event.preventDefault()