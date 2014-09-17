$(document).on 'click', '.done_status>button', (event)->
  $input = $(this).closest('.done_status').next('input')
  $input.val($(this).data('value'))
  console.log $input.val()
  event.preventDefault()