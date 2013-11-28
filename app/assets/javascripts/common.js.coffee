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

  $(document).on 'shown', '#modal_form', ->
    $('html,body').css('overflow', 'hidden');

  $(document).on 'hidden', '#modal_form', ->
    $('html,body').css 'overflow', 'auto'
    $('#modal_form').remove()
    $('.product_selector.active').removeClass('active')
    $('.product_select_button.active').removeClass('active')

  $(document).on 'keyup', '#search_form .search-query', (event) ->
    if event.keyCode is 13
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
    event.preventDefault()
    $('#card_sign_in').show().addClass('in')

  $(document).on 'click', '.close_popover_button', (event)->
    $popover = $(this).parents('.popover')
    $popover.prev().popover('hide')
    event.preventDefault()

  $('#scan_barcode_button').click ->
    scanBarcode()

  if $('table.enumerable').length > 0
    enumerate_table('table.enumerable')

cursorX = $('#spinner').outerWidth() / 2
cursorY = $('#spinner').outerHeight() / 2

$(document).on 'mousemove', '*', (event)->
  cursorX = event.pageX
  cursorY = event.pageY

$(document).on 'keydown', 'input[type=text]', ->
  cursorX = $(this).offset().left + $('#spinner').outerWidth() / 2
  cursorY = $(this).offset().top + this.clientHeight / 2

$(document).on 'keydown', 'textarea', ->
  cursorX = $(this).offset().left + $('#spinner').outerWidth() / 2
  cursorY = $(this).offset().top + $('#spinner').outerHeight() / 2

$(document).ajaxSend ->
  showSpinner()

$(document).ajaxComplete ->
  hideSpinner()

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

scanBarcode = ->
  scaned_code = ''
  $('#barcode_reader').fadeIn().addClass('in')
  $(document).on 'keydown', (event)->
    if $('#barcode_reader:visible').length > 0
      console.log event.keyCode
      if event.keyCode is 13 and scaned_code isnt ''
        ticket_number = scaned_code.replace(/^0+/, '')
        ticket_number = ticket_number[0..-2]
        $('#barcode_reader').removeClass('in').fadeOut()
        $.get '/devices/' + ticket_number + '.js?find=ticket'
      else
        if event.keyCode in [48..57]
          scaned_code = scaned_code[1..-1] if scaned_code.length is 12
          scaned_code += String.fromCharCode(event.keyCode)

  setTimeout (->
    $('#barcode_reader').removeClass('in').fadeOut()
  ), 5000

auth_timeout = auth_count = 5 * 60

#if $('#profile_link').data('role') is 'software'
#  setInterval (->
#    auth_count -= 1
#    if auth_count < 1 and $('#card_sign_in.in:visible').length is 0
#      $('#lock_session').click()
#  ), 1000

$(document).on 'click keydown mousemove', ->
  auth_count = auth_timeout

window.showSpinner = ()->
  $spinner = $('#spinner')
  $spinner.css
    left: cursorX-$spinner.outerWidth()/2,
    top: cursorY-$spinner.outerHeight()/2
  $spinner.fadeIn()

window.hideSpinner = ->
  $('#spinner').fadeOut()

window.hideModal = ->
  $('#modal_form').modal('hide')

window.enumerate_table = (table)->
  num = 0
  $('tbody>tr:visible', table).each ->
    $(this).find('.num').text(++num)

window.datepicker_dates =
  days: ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"],
  daysShort: ["Вск", "Пнд", "Втр", "Срд", "Чтв", "Птн", "Суб", "Вск"],
  daysMin: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"],
  months: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"],
  monthsShort: ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"],
  today: "Сегодня"

accounting.settings =
  currency:
    symbol: 'руб.'
    format: '%v %s'
    decimal: ','
    thousand: ' '
    precision: 0
  number:
    precision: 0
    decimal: ','
    thousand: ' '