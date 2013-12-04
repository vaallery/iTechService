$(document).on 'click', '#header_karma_good_true', ->
  $('#header_karma_good').val(true)

$(document).on 'click', '#header_karma_good_false', ->
  $('#header_karma_good').val(false)

$(document).on 'click', '.submit_karma_form', (event)->
  $('#user_karma_form').submit()
  showSpinner()
  event.preventDefault()

$(document).on 'click', '.close_karma_popover_button', ->
  $owner = $($(this).data('owner'))
  $owner.popover('destroy')

$(document).on 'click', '.user_karma_group_link', ->
  $("#user_karmas .has-tooltip").tooltip()

window.close_karma_popovers = ->
  $('.new_karma_link,.user_karma_link,#header_karma_link').popover('destroy')