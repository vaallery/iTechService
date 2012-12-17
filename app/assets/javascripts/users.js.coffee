# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#= require bootstrap-datepicker

jQuery ->

  markedCells = [null, null, null, null]

  $('#schedule_table tbody').mousedown (event) ->
    event.preventDefault()

  $('.schedule_hour').click (event) ->
    $this = $(this)
    if event.shiftKey and ((markedCells[0] isnt null) and (markedCells[1] isnt null))
      markedCells[2] = $this.prop('cellIndex')
      markedCells[3] = $this.parent().prop('rowIndex')
      fill_schedule_hours markedCells
      markedCells = [null, null, null, null]
    else
      markedCells[0] = $this.prop('cellIndex')
      markedCells[1] = $this.parent().prop('rowIndex')
      toggle_schedule_day $this
    fill_schedule_fields()
    event.preventDefault()
    false

  $('.datepicker').datepicker
    format: 'dd.mm.yyyy'
    weekStart: 1
    viewMode: 'years'
    minViewMode: 'day'

  $('td.calendar_day.work_day.empty', '#calendar.editable').click (event) ->
    $this = $(this)
    $fields = $('#duty_days_fields')
    this_date = $this.attr('date')
    $field_day = $("input[value=" + this_date + "]", $fields)

    if $field_day.length > 0
      fields_id = $field_day[0].id.match(/.+\d+_/)[0]
      $field_destroy = $("#" + fields_id + "_destroy", $fields)

    if $this.hasClass 'duty'
      if $field_destroy.length > 0
        $field_destroy.val 'true'
      else
        $field_day.remove()
      $this.removeClass 'duty'
    else
      if $field_day.length > 0
        $field_destroy.val 'false'
      else
        new_id = new Date().getTime()
        new_field = "<input id='user_duty_days_attributes_" + new_id + "_day' name='user[duty_days_attributes][" +
            new_id + "][day]' type='hidden' value='" + this_date + "'>"
        $fields.append new_field

      $this.addClass 'duty'
      alert('Укороченный день!') if $this.hasClass('shortened')

toggle_schedule_day = (el) ->
  el.toggleClass 'work_hour'

fill_schedule_hours = (cells) ->
  $log = $('#log')
  x = [cells[0], cells[2]]
  y = [cells[1]-1, cells[3]-1]
  $('#schedule_table>tbody>tr:eq('+y[0]+')').find('td:eq('+x[0]+')').toggleClass('work_hour')
  for row in [y[0]..y[1]]
    for col in [x[0]..x[1]]
      $('#schedule_table>tbody>tr:eq('+row+')').find('td:eq('+col+')').toggleClass('work_hour')

fill_schedule_fields = () ->
  $('tr.schedule_day','#schedule_table').each (i, row) ->
    day = $(row).attr('day')
    hours = $('td.schedule_hour.work_hour', row).map (i, hour) ->
      $(hour).attr 'hour'
    .get().join ','
    $('input.schedule_day_'+day).val hours
