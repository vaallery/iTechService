jQuery ->

  $('.new_comment_link').live 'click', (event)->
    $this = $(this)
    $this.parent().siblings('.popover-content').children('form').toggle()
