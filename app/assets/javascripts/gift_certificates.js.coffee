jQuery ->

  $('#issue_gift_certificate_link, #activate_gift_certificate_link').click (event)->
    card_number = ''
    url = $(this).data('url')
    $('#gift_certificate_reader form').attr('action', url)
    $('#gift_certificate_reader').show().addClass('in')
    $(document).on 'keydown', (event)->
      if $('#gift_certificate_reader.in:visible').length > 0
        if event.keyCode is 13 and card_number isnt ''
          #$.post url.replace(':id', card_number)
          $('#gift_certificate_reader form #number').val card_number
          $('#gift_certificate_reader form').submit()
          $('#gift_certificate_reader.in:visible').removeClass('in').hide()
          card_number = ''
        else
          card_number += String.fromCharCode(event.keyCode).toLowerCase()
    #event.preventDefault()
