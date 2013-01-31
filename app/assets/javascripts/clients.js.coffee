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

  $client_input = $('#client_input')
  if $client_input.length > 0

    $(document).on 'click', (event)->
      if $(this).parents('#clients_autocomplete_list').length is 0
        $('#clients_autocomplete_list').hide()

    $('#client_search').keyup ()->
      $this = $(this)
      if $this.val() is ''
        $('#device_client_id').val("");
        $('#order_customer_id').val("");
      else
        $.getScript '/clients/autocomplete.js?client_q='+$this.val()

    if $('#clients_autocomplete_list').length
      $('#clients_autocomplete_list').css
        left: $('#client_input').offset().left
        top: $('#client_input').offset().top + $('#client_input').outerHeight()

    $('#client_devices_resize_button').click ->
      $('.client_devices_list').slideToggle(100)

    placeClientDevices()

placeClientDevices = ()->
  $devices = $('#client_devices')
  $input = $('#client_input')
  $('#client_devices').css
    top: $input.offset().top - 6
    left: $input.offset().left + $input.outerWidth()
  if $('.client_devices_list', $devices).length > 0
    $devices.show()
  else
    $devices.hide()
