jQuery ->

  $(document).on 'click', '#history .close_history', (event) ->
    $history = $('#history')
    $history.remove()
    event.preventDefault()

  $(document).ready () ->
    $('form[data-remote]').bind 'ajax:before', () ->
      CKEDITOR.instances[instance].updateElement() for instance in CKEDITOR.instances

  $(document).on 'click', '.remove_fields', (event) ->
    $(this).prev("input[type=hidden]").val("1")
    $(this).closest(".fields").hide()
    event.preventDefault()

  $(document).on 'click', '.add_fields', (event) ->
    target = $(this).data 'selector'
    association = $(this).data 'association'
    content = $(this).data 'content'
    add_fields target, association, content
    event.preventDefault()

  $(document).on 'hidden', '#modal_form', ->
    $('html,body').css 'overflow', 'auto'
    $('#modal_form').remove()

  $(document).on 'keyup', '#search_form .search-query', (event) ->
    $('#search_form').submit()
    event.preventDefault()

  $(document).on 'click', '#search_form .clear_search_input', (event) ->
    $(this).siblings('.search-query').val ''
    $('#search_form').submit()
    event.preventDefault()

  $(document).on 'focus', '.datepicker', ->
    $(this).datepicker().dates = datepicker_dates

  $('#sign_in_by_card, #unlock_session').click (event)->
    event.preventDefault()
    scanCard()

  $('#lock_session').click (event)->
    $('#card_sign_in').show().addClass('in')

  $(document).on 'click', '.close_popover_button', (event)->
    $popover = $(this).parents('.popover')
    $popover.prev().popover('hide')
    false

add_fields = (target, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp "new_" + association, "g"
  $(target).append content.replace(regexp, new_id)

sign_in_by_card = (number)->
  current_user_id = $('#profile_link').data('id')
  $.getJSON '/sign_in_by_card', {card_number: number, current_user: current_user_id}, (data)->
    if window.location.pathname is "/users/sign_in"
      window.location.assign '/'
    else
      if data.id == current_user_id
        $('#card_sign_in').removeClass('in').hide()
      else
        window.location.assign '/'

scanCard = ->
  card_number = ''
  $('#card_sign_in').show().addClass('in')
  $(document).on 'keydown', (event)->
    if $('#card_sign_in.in:visible').length > 0
      if event.keyCode is 13 and card_number isnt ''
        sign_in_by_card card_number
      else
        card_number += String.fromCharCode(event.keyCode).toLowerCase()
  setTimeout (->
    unless card_number is ''
      sign_in_by_card card_number
    else
      $('#card_sign_in').removeClass('in').hide() if window.location.pathname is "/users/sign_in"
    card_number = ''
   ), 3000

auth_timeout = auth_count = 5*60

setInterval (->
  auth_count -= 1
  if auth_count < 1 and $('#card_sign_in.in:visible').length == 0
    $('#lock_session').click()
), 1000

$(document).on 'click keydown mousemove', ->
  auth_count = auth_timeout

datepicker_dates =
  days: ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"],
  daysShort: ["Вск", "Пнд", "Втр", "Срд", "Чтв", "Птн", "Суб", "Вск"],
  daysMin: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"],
  months: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"],
  monthsShort: ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"],
  today: "Сегодня"
