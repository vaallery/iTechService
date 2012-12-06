# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  $('#check_phone_number').live 'click', (event) ->
    unless $(this).hasClass 'disabled'
      number = $('#client_phone_number').val()
      $.get '/clients/check_phone_number.js',
        number: number
    event.preventDefault()

  $('#client_phone_number').live 'keyup', (event) ->
    count = $('#client_phone_number').val().length
    $('#phone_length').text(count)
    if count in [6,7,10,11]
      $('#check_phone_number').removeClass('disabled')
    else
      $('#check_phone_number').addClass('disabled')
