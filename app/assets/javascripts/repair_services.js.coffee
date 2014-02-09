$(document).on 'click', '#close_repair_service_choose_form', (event)->
  event.preventDefault()
  $('#repair_services_choose_form_container').slideUp()