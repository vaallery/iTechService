jQuery ->

  $(document).on 'click', '.new_comment_link', (event)->
    $this = $(this)
    $this.parent().siblings('.popover-content').children('form').toggle()
