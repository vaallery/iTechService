jQuery ->

  $('#coffer_order_link').popover()

  $(document).on 'click', '.close_announcement_button', ->
    $(this).parent().hide()

  $(document).on 'click', '.change_announce_state_button', ->
    $this = $(this)
    state = !$this.data('state')
    $.ajax
      type: 'PUT'
      dataType: 'json'
      url: 'announcements/' + $this.data('id') + '.json'
      data:
        announcement:
          active: state
      success: (data)->
        $this.data('state', data.active)
        if data.active
          $this.removeClass('icon-check-empty').addClass('icon-check')
        else
          $this.removeClass('icon-check').addClass('icon-check-empty')
      error: (jqXHR, textStatus, errorThrown)->
        alert jqXHR.status+' ('+errorThrown+')'
