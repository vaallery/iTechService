jQuery ->
  $('.user_karma_link').each (i, el)->
    $(el).tooltip
      html: true
      title: $(this).data('comment')

  $(document).on 'click', '.submit_karma_form', (event)->
    event.preventDefault()
    $('#user_karma_form').submit()

window.close_karma_popovers = ->
  if $('#user_karma_form').length > 0
    $('#user_karma_form').parents('.popover').prev().popover('destroy')
