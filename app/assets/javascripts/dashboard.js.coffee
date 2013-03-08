
jQuery ->

  $('.device_tasks_toggle').click ->
    $(this).parents('.device_row').nextAll('.device_task_row.success').toggle()

  $('#dashboard_navigation a').click ->
    $(document).ajaxSend (event, xhr, options)->
     if options.url.substr(0, 10) == '/dashboard'
       $('#dashboard_content').fadeOut()
       $('.actual_tasks_nav.open>a[data-toggle=dropdown]').dropdown('toggle')
    $li = $(this).parent()
    $li.siblings('.active').removeClass('active')
    $li.addClass('active')
    $(document).ajaxComplete (event, req, options)->
      if options.url.substr(0, 10) == '/dashboard'
        $('#dashboard_content').fadeIn()

  $('.report_task_details').click ->
    $task_row = $(this).parents('.task_row')
    $task_row.nextUntil('.task_row').slideToggle()
    false

  $('#reports_tables .detailable>td').click ->
    $row = $(this).parents('tr')
    $row.nextUntil('.detailable').toggle()

  $('#reports_select a').click ->
    $this = $(this)
    $('#selected_report span').text $this.text()
    $('#reports_filter #report').val $this.data('report')
