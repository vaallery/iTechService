
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

#pageTime = new Date()

#newDevicesCheck = setInterval (->
#  time = pageTime.toLocaleString()
#  $.getJSON '/dashboard.json?time='+time, (data)->
#    if data.new_devices_exists
#      $('#new_device_popup').fadeIn()
#), 5000
