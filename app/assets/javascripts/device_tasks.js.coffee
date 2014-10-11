$(document).on 'click', '.done_status>a', (event)->
  $input = $(this).closest('.done_status').next('input')
  $input.val($(this).data('value'))
  event.preventDefault()