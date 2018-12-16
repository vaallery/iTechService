jQuery ->

  product_groups_tree('#product_groups') if $('#product_groups').length > 0

window.product_groups_tree = (container)->
  $.jstree._themes = "/assets/jstree/"
  $container = $(container)
  root_id = $container.data('root_id')
  group_id = $container.data('product_group_id')
  opened = $container.data('opened')
  $container.bind("create.jstree",(e, data)->
    $.post "/product_groups/",
      parent_id: data.rslt.parent[0].id
      product_group_name: data.rslt.name
    , (new_id)->
      $("li:not([id*=product_group_])", $container).attr("id", "product_group_#{new_id}")
  ).bind("remove.jstree",(e, data)->
    $.ajax
      type: "DELETE"
      url: "/product_groups/#{data.rslt.obj[0].id.replace("product_group_", "")}"
  ).bind("rename.jstree",(e, data)->
    $.ajax
      type: "PUT"
      url: "/product_groups/#{data.rslt.obj[0].id.replace("product_group_", "")}"
      data:
        product_group:
          name: data.rslt.new_name
  ).bind('select_node.jstree', (e, data)->
    $container.jstree('open_node', data.rslt.obj[0])
  ).bind("move_node.jstree", (e, data)->
    moved_group_id = data.rslt.o[0].dataset.productGroupId
    target_group_id = data.rslt.r[0].dataset.productGroupId
    $.ajax
      type: "PUT"
      url: "/product_groups/#{moved_group_id}"
      data:
        product_group:
          parent_id: target_group_id

#  ).bind('drag_finish.jstree', (e, data)->
#    alert 'drag_finish'
#  ).bind('drop_finish.jstree', (e, data)->
#    alert 'drop_finish'
  ).jstree(
    core:
      strings:
        loading: "Загружаю..."
        new_node: "Новая Продуктовая Группа"
      initially_open: opened
      load_open: true
      open_parents: true
      animation: 10
    themes:
      theme: "apple"
      dots: false
      icons: false
    ui:
      select_limit: 1
#    dnd:
#      drop_finish: ->
#        alert 'drop_finish'
#      drag_finish: (data)->
#        alert 'drag_finish'
#        parent_id = data.r.obj[0].id.replace("product_group_", "")
#        $.ajax
#          type: "PUT"
#          url: "/product_groups/#{data.o.obj[0].id.replace("product_group_", "")}"
#          data:
#            product_group:
#              parent_id: parent_id
#        json_data:
#          ajax:
#            url: "/product_groups/#{root_id}.json"
#            data: (n)->
#              id: (if n.attr then n.attr("id") else 0)
    contextmenu:
      select_node: true
      items:
        create:
          label: "Создать"
          action: (obj)->
            group_id = obj[0].id.replace("product_group_", "")
            $.get "/product_groups/new.js", {product_group: {parent_id: group_id}}
          separator_after: true
        rename:
          label: "Редактировать"
          action: (obj)->
            group_id = obj[0].id.replace("product_group_", "")
            $.get "/product_groups/#{group_id}/edit.js"
          separator_after: true
        remove:
          label: "Удалить"
          action: (obj)->
            if confirm("Вы уверены?")
              if @is_selected(obj)
                @remove()
              else
                @remove obj
    plugins: ["themes", "html_data", "ui", "contextmenu", "crrm", "dnd"]
  ).show()

window.product_groups_tree_readonly = (container)->
  $.jstree._themes = "/assets/jstree/"
  $container = $(container)
  root_id = $container.data('root_id')
  $container.bind('select_node.jstree', (e, data)->
    $container.jstree('open_node', data.rslt.obj[0])
  ).jstree(
    core:
      strings:
        loading: "Загружаю..."
        new_node: "Новая Продуктовая Группа"
      load_open: true
      open_parents: true
      animation: 10
    themes:
      theme: "apple"
      dots: false
      icons: false
    ui:
      select_limit: 1
    plugins: ["themes", "html_data", "ui"]
  ).show()
