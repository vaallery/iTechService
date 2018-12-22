jQuery ->

  $(document).on 'click', '.new_comment_link', (event)->
    $this = $(this)
    $this.parent().siblings('.popover-content').children('form').toggle()

  $comments = $('#comments')

  if $comments.length > 0
    $comments.scrollTop($comments[0].scrollHeight)
