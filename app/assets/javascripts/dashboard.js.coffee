
jQuery ->

  $('.device_tasks_toggle').click ->
    $(this).parents('.device_row').nextAll('.device_task_row.success').toggle()

  $('#dashboard_navigation a').click ->
    $(document).ajaxSend ->
     $('#dashboard_content').fadeOut()
     $('.actual_tasks_nav.open>a[data-toggle=dropdown]').dropdown('toggle')
    $li = $(this).parent()
    $li.siblings('.active').removeClass('active')
    $li.addClass('active')
    $(document).ajaxComplete ->
      $('#dashboard_content').fadeIn()
