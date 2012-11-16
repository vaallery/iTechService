# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  
  $('.device_task_task').live 'change', () ->
    task_id = $(this).val()
    task_cost = $(this).parents('.device_task').find('.device_task_cost')
    $.getJSON '/tasks/'+task_id+'.json', (data) ->
      task_cost.val data.cost
      
  $('#search_devices_form').on 'keyup', '.search-query', (event) ->
    $('#search_devices_form').submit()
    event.preventDefault()

  $('#search_devices_form').on 'click', '.clear_search_input', (event) ->
    $(this).siblings('.search-query').val ''
    $('#search_devices_form').submit()
    event.preventDefault()