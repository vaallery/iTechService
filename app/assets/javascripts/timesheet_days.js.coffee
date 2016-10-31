jQuery ->

  $('#timesheet_datepicker').datepicker(
  ).on('changeDate',(ev)->
    date = ev.date
    url = $('#timesheet_datepicker').data('url')
    $('#timesheet_datepicker').datepicker('hide')
    $('#timesheet_table_container').slideUp('fast')
    $.get url, { date: date }, null, 'script'
  ).dates = datepicker_dates

$(document).on 'click', 'td.timesheet_day', ->
  $cell = $(this)
  id = $cell.data('id')
  date = $cell.data('date')
  user = $cell.parents('.timesheet_row').data('user')
  if id is ''
    $.get '/timesheet/new.js', { timesheet_day: { user_id: user, date: date } }
  else
    $.get '/timesheet/'+id+'/edit.js'

#$(document).on 'moseenter', 'td.timesheet_day.salary_day', ->
#  $cell = $(this)
#  user = $cell.parents('.timesheet_row').data('user')
#  $.get "/user/#{user}/faults.js"

$(document).on 'click', '.submit_timesheet_day_form', (event)->
  $('#timesheet_day_form').submit()
  event.preventDefault()

$(document).on 'click', '.close_timesheet_popover', (event)->
  close_timesheet_popover()
  event.preventDefault()
  false

$(document).on 'change', '#timesheet_day_status', ->
  $this = $(this)
  $form = $('#timesheet_day_form')
  $popover = $form.parents('.popover')
  $cell = $('td.timesheet_day.editing')
  if $this.val() in ['presence_late', 'presence_leave']
    $('.time_input', $form).removeClass('hidden')
  else
    $('.time_input', $form).addClass('hidden')
  $popover.css top: $cell.offset().top-$popover.outerHeight()

window.close_timesheet_popover = ->
  $('td.timesheet_day.editing').popover('destroy')