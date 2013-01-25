
jQuery ->

  $('.device_tasks_toggle').click ->
    $(this).parents('.device_row').nextAll('.device_task_row.success').toggle()

  $('#dashboard_navigation a').click ->
    $('#dashboard_content').fadeOut()
    $li = $(this).parent()
    $li.siblings('.active').removeClass('active')
    $li.addClass('active')
    $(document).ajaxComplete ->
      $('#dashboard_content').fadeIn()
