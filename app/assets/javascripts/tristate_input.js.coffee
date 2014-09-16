$(document).on 'click', '.tristate>button', (event)->
  $input = $(this).closest('.tristate').next('input')
  $input.val($(this).data('value'))
  console.log $input.val()
  event.preventDefault()