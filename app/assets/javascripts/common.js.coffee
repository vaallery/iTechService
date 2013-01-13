jQuery ->

  $(document).ready () ->
    $('form[data-remote]').bind 'ajax:before', () ->
      CKEDITOR.instances[instance].updateElement() for instance in CKEDITOR.instances

  $(document).on 'click', '.remove_fields', (event) ->
    $(this).prev("input[type=hidden]").val("1")
    $(this).closest(".fields").hide()
    event.preventDefault()

  $(document).on 'click', '.add_fields', (event) ->
    target = $(this).data 'selector'
    association = $(this).data 'association'
    content = $(this).data 'content'
    add_fields target, association, content
    event.preventDefault()

  $(document).on 'hidden', '#modal_form', (event) ->
    $('html,body').css 'overflow', 'auto'
    $('#modal_form').remove()

  $(document).on 'keyup', '#search_form .search-query', (event) ->
    $('#search_form').submit()
    event.preventDefault()

  $(document).on 'click', '#search_form .clear_search_input', (event) ->
    $(this).siblings('.search-query').val ''
    $('#search_form').submit()
    event.preventDefault()

add_fields = (target, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp "new_" + association, "g"
  $(target).append content.replace(regexp, new_id)
