# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
# require jquery
#= require jquery_ujs
#= require jquery-ui
#= require twitter/bootstrap
#= require autocomplete-rails
#= require jquery.jstree
#= require_self
# require_tree .


#ready = ->
#$('form').on 'click', '.remove_fields', (event) ->
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
