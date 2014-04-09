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
  if depth? or depth is 0
    if $row.hasClass 'open'
      $row.nextAll('.details').each ->
        this_depth = Number($(this).data('depth'))
        if this_depth > depth
          $(this).removeClass('open').hide()
        else
          return false
      $row.removeClass('open')
    else
      $row.nextAll('.details').each ->
        this_depth = Number($(this).data('depth'))
        $(this).show() if this_depth == depth+1
        if this_depth <= depth
          return false
      $row.addClass('open')
  else
    $row.nextUntil('.detailable').toggle()

$(document).on 'click', '#report_result .toggle_depth', ->
  depth = Number $(this).data('depth')
  $table = $('#report_result table')
  $('.detailable[data-depth='+depth-1+']')