# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  $('#check_phone_number').live 'click', (event) ->
    unless $(this).hasClass 'disabled'
      number = $('#client_full_phone_number').val()
      $.get '/clients/check_phone_number.js',
        number: number
    event.preventDefault()

  $('#client_full_phone_number').live 'keyup', (event) ->
    $('#check_phone_number').removeClass('btn-success').removeClass('btn-warning')
    count = $('#client_full_phone_number').val().length
    $('#phone_length').text(count)
    if count in [6,7,10,11]
      $('#check_phone_number').removeClass('disabled').addClass('btn-warning')
    else
      $('#check_phone_number').addClass('disabled').removeClass('btn-warning')

  $('#client_card_number').live 'keyup', ->
    if $(this).val() isnt ''
      $('#client_questionnaire_input').removeClass 'hidden'
    else
      $('#client_questionnaire_input').addClass 'hidden'