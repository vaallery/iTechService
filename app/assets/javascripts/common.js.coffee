jQuery ->

# Loading info and announcements

  if $('#important_info').length
    $('#important_info').load '/infos?important=t', ->
      if $('#important_info>*').length
        $('#important_info').slideDown(100)
        showNotificationsIndicator()

  if $('#personal_infos').length
    $('#personal_infos').load '/infos?personal=t', ->
      if $('#personal_infos>*').length
        $('#personal_infos').slideDown(100)
        showNotificationsIndicator()

  if $('#announcements').length
    $('#announcements').load '/announcements?actual=t', ->
      if $('#announcements>*').length
        $('#announcements').slideDown(100)
        showNotificationsIndicator()

  $(document).ready () ->
    $('form[data-remote]').bind 'ajax:before', () ->
      CKEDITOR.instances[instance].updateElement() for instance in CKEDITOR.instances

  $('#sign_in_by_card, #unlock_session').click (event)->
    event.preventDefault()
    scanCard()

  $('#lock_session').click (event)->
    event.preventDefault()
    $('#card_sign_in').show().addClass('in')

  $('#scan_barcode_button').click ->
    scanTicket()

  $('.color_input>.color_template').css 'background-color', $('.color_value').val()

  $('.color_input>.color_value').colorpicker().on 'changeColor', (event)->
    $('.color_input>.color_template').css 'background-color', event.color.toHex()

  if $('table.enumerable').length > 0
    enumerate_table('table.enumerable')

$(document).on 'click', '.close_popover_button', (event)->
  $popover = $(this).parents('.popover')
  $popover.prev().popover('hide')
  event.preventDefault()

$(document).on 'click', '#hide_notifications_button', ->
  $('#announcements:has(*)').slideToggle(100);
  $('#personal_infos:has(*)').slideToggle(100);
  $('#important_info:has(*)').slideToggle(100);
  $('#duty_announcement:has(*)').slideToggle(100);
  $('#hide_notifications_button>i').toggleClass('icon-chevron-up').toggleClass('icon-chevron-down')

$(document).on 'click', '#history .close_history', (event) ->
  $history = $('#history')
  $history.remove()
  event.preventDefault()

$(document).on 'click', '.remove_fields', (event) ->
  $(this).prev("input[type=hidden]").val("1")
  $(this).closest(".fields").hide()
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

$(document).on 'click', '#cancel_barcode_scan', ->
  closeBarcodeReader()

$(document).on 'click', '.add_fields', (event) ->
  event.preventDefault()
  target = $(this).data 'selector'
  association = $(this).data 'association'
  content = $(this).data 'content'
  add_fields target, association, content

cursorX = $('#spinner').outerWidth() / 2
cursorY = $('#spinner').outerHeight() / 2

$(document).on 'click', '.close_popover_button', ->
  $owner = $($(this).data('owner'))
  $owner.popover('destroy')

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

scanTicket = ->
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

$(document).on 'click keydown mousemove', ->
  auth_count = auth_timeout

window.showScanner = (object_type)->
  scanned_number = ''
  $('#card_scanner').show().addClass('in').addClass(object_type)
  $(document).on 'keydown', '#card_scanner.in:visible', (event)->
    if $('#card_scanner.in:visible').length > 0
      if event.keyCode is 13 and scanned_number isnt ''
        hideScanner()
        switch object_type
          when 'gift_certificate' then $.get('/gift_certificates/'+scanned_number+'/find.js')
        scanned_number = ''
      else
        scanned_number += String.fromCharCode(event.keyCode).toLowerCase()
  setTimeout (->
    scanned_number = ''
    hideScanner()
  ), 5000

window.hideScanner = ->
  $('#card_scanner_inner input').val('')
  $('#card_scanner').removeClass('in').hide()

window.closeBarcodeReader = ->
  $('#barcode_reader #barcode_field').val('')
  $('#barcode_reader').removeClass('in').fadeOut()

window.showSpinner = ()->
  $spinner = $('#spinner')
  $spinner.css
    left: cursorX-$spinner.outerWidth()/2,
    top: cursorY-$spinner.outerHeight()/2
  $spinner.fadeIn()

window.hideSpinner = ->
  $('#spinner').fadeOut()

window.closeAnnouncement = ($announcement)->
#  $announcement.css({position: 'fixed', left: $announcement.offset().left, top: $announcement.offset().top, width: $announcement.outerWidth()})
#  $announcement.animate({left: $('body').outerWidth()}, 200).remove()
  $announcement.slideUp 100, ->
    $announcement.remove()
    hideNotificationsIndicator() unless $('#announcements>*, #important_info>*, #personal_infos>*').length

window.showNotificationsIndicator = ->
  $('#hide_notifications_button>.indicator').addClass('active')

window.hideNotificationsIndicator = ->
  $('#hide_notifications_button>.indicator').removeClass('active')

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
    #format: '%v %s'
    format: '%v'
    decimal: ','
    thousand: ' '
    precision: 2
  number:
    precision: 2
    decimal: ','
    thousand: ' '