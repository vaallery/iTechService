jQuery ->

  $('#issue_gift_certificate_link, #activate_gift_certificate_link, #check_gift_certificate_link').click (event)->
    card_number = ''
    operation = ''
    $this = $(this)
    url = $this.data('url')
    $('#gift_certificate_reader').data('operation', 'issue') if $this.attr('id') is 'issue_gift_certificate_link'
    $('#gift_certificate_reader').data('operation', 'activate') if $this.attr('id') is 'activate_gift_certificate_link'
    $('#gift_certificate_reader').data('operation', 'check') if $this.attr('id') is 'check_gift_certificate_link'
    $('#gift_certificate_reader').show().addClass('in')
    $(document).on 'keydown', (event)->
      if $('#gift_certificate_reader.in:visible').length > 0
        if event.keyCode is 13 and card_number isnt ''
          $('#gift_certificate_reader.in:visible').removeClass('in').hide()
          $.get '/gift_certificates/scan?number='+card_number+'&operation='+$('#gift_certificate_reader').data('operation')
          card_number = ''
        else
          card_number += String.fromCharCode(event.keyCode).toLowerCase()
    event.preventDefault()
