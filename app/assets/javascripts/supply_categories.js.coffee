jQuery ->

  $.jstree._themes = "assets/jstree/"
  buildSupplyCategoriesTree()

window.buildSupplyCategoriesTree = ->
  $('#supply_categories_tree')
  .bind 'create.jstree', (e, data)->
    $.ajax
      type: 'POST'
      url: 'supply_categories.json'
      data:
        supply_category:
          parent_id: $(data.rslt.parent[0]).data('supply-category-id')
          name: data.rslt.name
      success: (resp)->
        $("#supply_categories_tree li:not([id*=supply_category_])").attr('id', 'supply_category_' + resp.id).data('supply-category-id', resp.id).addClass('supply_category')
      error: (data, status, e)->
        alert data.responseText
  .bind 'remove.jstree', (e, data)->
    $.ajax
      type: 'DELETE'
      url: 'supply_categories/' + $(data.rslt.obj[0]).data('supply-category-id') + '.json'
  .bind 'rename.jstree', (e, data)->
    $.ajax
      type: 'PUT'
      url: 'supply_categories/' + $(data.rslt.obj[0]).data('supply-category-id') + '.json'
      data:
        supply_category:
          name: data.rslt.new_name
      error: (data, status, e)->
        alert data.responseText
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
            label: jstree_i18n.create
            separator_after: true
            action: (obj)->
              this.create obj
          rename:
            label: jstree_i18n.rename
            separator_after: true
            action: (obj)->
              this.rename obj
          remove:
            label: jstree_i18n.delete
            action: (obj)->
              if confirm(jstree_i18n.confirmation)
                if this.is_selected(obj) then this.remove() else this.remove(obj)
      plugins: ['themes', 'html_data', 'ui', 'contextmenu', 'crrm']
  .bind 'loaded.jstree', (e, data)->
      $('#supply_categories_tree').jstree('open_all', $('li.supply_category'), false)
  .fadeIn(100)