jQuery ->

  $('#report_name').change ->
    if $(this).val() == 'remnants'
      $('#report_store_id').show()
    else
      $('#report_store_id').hide()

$(document).on 'click', '.report_task_details', ->
  $task_row = $(this).parents('.task_row')
  $task_row.nextUntil('.task_row').slideToggle()
  false

$(document).on 'click', '#report_result .detailable>td', ->
  $row = $(this).closest('tr')
  depth = Number($row.data('depth'))
  if $row.hasClass 'open'
    $row.nextUntil('.detailable[data-depth='+depth+']').removeClass('open').hide()
#    $row.next('.details').each ->
#      this_depth = Number($(this).data('depth'))
#      if this_depth < depth
#        $(this).removeClass('open').hide()
#      else
#        break
    $row.removeClass('open')
  else
    $row.nextUntil('.detailable[data-depth='+depth+']').filter('.details[data-depth='+(depth+1)+']').show()
#    $row.next('.details').each ->
#      this_depth = Number($(this).data('depth'))
#      $(this).show() if this_depth == depth+1
#      if this_depth >= depth
#        break
    $row.addClass('open')

$(document).on 'click', '#report_result .toggle_depth', ->
  depth = Number $(this).data('depth')
  $table = $('#report_result table')
  $('.detailable[data-depth='+depth-1+']')