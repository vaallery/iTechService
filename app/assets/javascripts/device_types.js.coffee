# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

  $.jstree._themes = "assets/jstree/"
  $('#device_types_tree')
    .bind 'create.jstree', (e, data) ->
      $.post "device_types.json",
        device_type:
          parent_id: $(data.rslt.parent[0]).attr('device_type_id')
          name: data.rslt.name
      , (resp) ->
        $("#device_types_tree li:not([id*=device_type_])").attr('id', 'device_type_'+resp.id)
          .attr('device_type_id', resp.id).addClass('device_type')
    .bind 'remove.jstree', (e, data) ->
      $.ajax
        type: 'DELETE'
        url: 'device_types/'+$(data.rslt.obj[0]).attr('device_type_id')+'.json'
    .bind 'rename.jstree', (e, data) ->
      $.ajax
        type: 'PUT'
        url: 'device_types/'+$(data.rslt.obj[0]).attr('device_type_id')+'.json'
        data:
          device_type:
            name: data.rslt.new_name
    .jstree
      core:
        load_open: true
        open_parents: true
        animation: 10
      themes:
        theme: 'apple'
        dots: true
        icons: false
      ui:
        select_limit: 1
      contextmenu:
        select_menu: true
        items:
          create:
            label: 'create'
            separator_after: true
            action: (obj) ->
              this.create obj
          rename:
            label: 'rename'
            separator_after: true
            action: (obj) ->
              this.rename obj
          remove:
            label: 'delete'
            action: (obj) ->
              if confirm('Are you sure?')
                if this.is_selected(obj) this.remove() else this.remove(obj)
      plugins: ['themes', 'html_data', 'ui', 'contextmenu', 'crrm']
    .bind  'loaded.jstree', (e, data) ->
      $('#device_types_tree').jstree('open_all', $('li.device_type'), false)


#  $('#device_types_tree .label').live 'click', () ->
#    $('#device_types_tree .label').removeClass('label-info')
#    $(this).addClass('label-info')
#    $('#device_type_parent_id').val($(this).closest('li').attr('device_type_id'))
#
#  $('#device_types_tree ins.tree_icon').live 'click', () ->
#    $(this).siblings('ul').slideToggle 100, () ->
#      $(this).closest('li').toggleClass 'closed'
#      $(this).closest('li').toggleClass 'opened'
