#ready = ->
#$('form').on 'click', '.remove_fields', (event) ->
jQuery ->

  $(document).ready () ->
    $('form[data-remote]').bind 'ajax:before', () ->
      CKEDITOR.instances[instance].updateElement() for instance in CKEDITOR.instances

  $(document).on 'click', '.remove_fields', (event) ->
    $(this).prev("input[type=hidden]").val("1")
    $(this).closest(".fields").hide()
    event.preventDefault()

  #$('form').on 'click', '.add_fields', (event) ->
  $(document).on 'click', '.add_fields', (event) ->
    target = $(this).data 'selector'
    association = $(this).data 'association'
    content = $(this).data 'content'
    add_fields target, association, content
    event.preventDefault()

  #$('#modal_form').live 'hidden', (event) ->
  $(document).live 'hidden', '#modal_form', (event) ->
    $('html,body').css 'overflow', 'auto'
    $('#modal_form').remove()

  $(document).on 'keyup', '#search_form .search-query', (event) ->
    $('#search_form').submit()
    event.preventDefault()

  $(document).on 'click', '#search_form .clear_search_input', (event) ->
    $(this).siblings('.search-query').val ''
    $('#search_form').submit()
    event.preventDefault()

#$(document).ready(ready)
#$(document).on('page:load', ready)

add_fields = (target, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp "new_" + association, "g"
  $(target).append content.replace(regexp, new_id)
