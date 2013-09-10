jQuery ->

  if $('#product_groups').length > 0
#    $("#product_groups>.product_groups_tree").each (i, element)->
    product_groups_tree('#product_groups')

window.product_groups_tree = (container)->
  $.jstree._themes = "/assets/jstree/"
  $container = $(container)
  root_id = $container.data('root_id')
  group_id = $container.data('product_group_id')
  opened = $container.data('opened')
  $container.bind("create.jstree",(e, data) ->
    $.post "/product_groups/",
      parent_id: data.rslt.parent[0].id
      product_group_name: data.rslt.name
    , (new_id) ->
      $("li:not([id*=product_group_])", $container).attr("id", "product_group_#{new_id}")

  ).bind("remove.jstree",(e, data) ->
    $.ajax
      type: "DELETE"
      url: "/product_groups/#{data.rslt.obj[0].id.replace("product_group_", "")}"

  ).bind("rename.jstree",(e, data) ->
    $.ajax
      type: "PUT"
      url: "/product_groups/#{data.rslt.obj[0].id.replace("product_group_", "")}"
      data:
        product_group:
          name: data.rslt.new_name

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

    dnd:
      drop_finish: ->
        json_data:
          ajax:
            url: "/product_groups/#{root_id}.json"
            data: (n) ->
              id: (if n.attr then n.attr("id") else 0)

    contextmenu:
      select_node: true
      items:
        create:
          label: "Создать"
          action: (obj) ->
            group_id = obj[0].id.replace("product_group_", "")
            $.get "/product_groups/new.js", {product_group: {parent_id: group_id}}

          separator_after: true

        edit:
          label: "Редактировать"
          action: (obj) ->
            group_id = obj[0].id.replace("product_group_", "")
            $.get "/product_groups/#{group_id}/edit.js"

        rename:
          label: "Переименовать"
          action: (obj) ->
            @rename obj

          separator_after: true

        remove:
          label: "Удалить"
          action: (obj) ->
            if confirm("Вы уверены?")
              if @is_selected(obj)
                @remove()
              else
                @remove obj

    plugins: ["themes", "html_data", "ui", "contextmenu", "crrm"]
  )#.bind "select_node.jstree", (e, data) ->
#    @toggle_select(data.rslt.obj[0])
#    group_id = data.rslt.obj[0].id.replace("product_group_", "")
#    $('#new_product_group_link')
#    url = data.rslt.obj[0].children[1].href.replace("?", ".js?")
#    $.get url

