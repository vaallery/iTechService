jQuery ->
  bindKarmaGroupEvents('#user_karmas .karma_group_link')
  bindKarmaEvents('#user_karmas .karma_link')

  $('#user_karmas>div.good').selectable
    cancel: '.karma_group_link,.karma_link'
    filter: '.karma_link'
    stop: ->
      $selected_karmas = $(this).children('.karma_link.ui-selected')
      if $selected_karmas.length > 1
        showCreateKarmaGroupForm $selected_karmas.map(-> $(this).data('id')).get()
      else
        hideCreateKarmaGroupForm()

  $('#karma_group_karma_qty').focusin ->
    $('#karma_group_karma_qty').attr 'max', $('#user_karmas>.good>.karma_link').length

  $('#karma_group_karma_qty').on 'change keyup', ->
    qty = $(this).val()
    $('#user_karmas>.good>.karma_link.ui-selected').removeClass 'ui-selected'
    if qty > 0
      selected_ids = []
      $('#user_karmas>.good>.karma_link')[0..qty-1].each ->
        $(this).addClass 'ui-selected'
        selected_ids.push $(this).data('id')
      $('#karma_group_karma_ids').val selected_ids
    else
      $('#karma_group_karma_ids').val null

  $('#select_karmas_button').click ->
    showCreateKarmaGroupForm()

  $('#close_karma_group_form_link').click ->
    hideCreateKarmaGroupForm()

$(document).on 'click', '#header_karma_good_true', ->
  $('#header_karma_good').val(true)

$(document).on 'click', '#header_karma_good_false', ->
  $('#header_karma_good').val(false)

$(document).on 'click', '.submit_karma_form', ->
  $('#karma_form').submit()

window.bindKarmaGroupEvents = (karma_group)->
  $(karma_group).droppable(karma_group_droppable_params)

window.bindKarmaEvents = (karma)->
  $(karma).filter('.good').draggable(karma_draggable_params).droppable(karma_droppable_params)
  $(karma).tooltip()

window.closeKarmaPopovers = ->
  $('.new_karma_link, .karma_link').popover('destroy')

window.showCreateKarmaGroupForm = (selected_ids)->
  if selected_ids
    $('#karma_group_karma_ids').val selected_ids
    $('#karma_group_karma_qty').val selected_ids.length
  $('#select_karmas_button').hide()
  $('#create_karma_group_form').show()

window.hideCreateKarmaGroupForm = ->
  $('#karma_group_karma_ids').val null
  $('#karma_group_karma_qty').val null
  $('#create_karma_group_form').hide()
  $('#select_karmas_button').show()

karma_draggable_params =
  distance: 20
  revert: true
  revertDuration: 100
  stop: (event, ui)->
    $this = $(this)
    if $this.hasClass('grouped') and event.toElement != $(this).parent() and !$(event.toElement.parentElement).hasClass('karma_link')
      $.post '/karmas/ungroup',
        id: $(this).data 'id'
    else
      $(this).css top: 0, left: 0

karma_droppable_params =
  accept: '.karma_link.good'
  hoverClass: 'drop-hover'
  drop: (event, ui)->
    $.post '/karmas/group',
      id1: $(this).data 'id'
      id2: $(ui.draggable[0]).data 'id'

karma_group_droppable_params =
  accept: '.karma_link.good'
  hoverClass: 'drop-hover'
  drop: (event, ui)->
    $.post '/karmas/addtogroup',
      id: $(ui.draggable[0]).data 'id'
      karma_group_id: $(this).data 'id'
