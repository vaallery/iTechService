# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  markedCells = [null, null, null, null]

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
    event.preventDefault()

  $('#schedule_table>tbody')

toggle_schedule_day = (el) ->
  el.toggleClass 'work'
  fill_schedule_fields()

fill_schedule_hours = (cells) ->
  $log = $('#log')
  x = [cells[0], cells[2]]
  y = [cells[1]-1, cells[3]-1]
  $('#schedule_table>tbody>tr:eq('+y[0]+')').find('td:eq('+x[0]+')').removeClass('work')
  for row in [y[0]..y[1]]
    for col in [x[0]..x[1]]
      $('#schedule_table>tbody>tr:eq('+row+')').find('td:eq('+col+')').toggleClass('work')

fill_schedule_fields = () ->
  $('tr.schedule_day','#schedule_table').each (i, row) ->
    day = $(row).attr('day')
    hours = $('td.schedule_hour.work', row).map (i, hour) ->
      $(hour).attr 'hour'
    .get().join ','
    $('input.schedule_day_'+day).val hours
