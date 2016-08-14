$(document).on 'click', '[data-behavior~=close_secondary_form]', (event)->
  event.preventDefault()
  $('#secondary_form_container').fadeOut()
  $('#secondary_form_container').html('');
