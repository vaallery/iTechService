jQuery ->
  make_tree('repair_groups') if $('#repair_groups').length > 0

window.make_tree = (collection)->
  $container = $('#'+collection)
  $.jstree._themes = "/assets/jstree/"
  root_id = $container.data('root_id')
  model_name = $container.data('model_name')
  object_id = $container.data(model_name+'_id')
  $container.bind('create.jstree', (e, data)->
    $.post "/#{collection}/",
      parent_id: data.rslt.parent[0].id
      "#{model_name}_name" => data.rslt.name
    , (new_id)->
      $("li:not([id*=#{model_name}])", $container).attr('id', "#{model_name}_#{new_id}")
  ).bind("remove.jstree", (e, data)->
    $.ajax
      type: "DELETE"
      url: "/#{collection}/#{data.rslt.obj[0].id.replace("#{model_name_}", "")}"
  ).bind("rename.jstree", (e, data)->
    $.ajax
      type: "PUT"
      url: "/#{collection}/#{data.rslt.obj[0].id.replace("#{model_name}", "")}"
#      data:
#        "#{model_name}"
#          name: data.rslt.new_name
  ).jstree(
    core:
      strings:
        loading: "Загружаю..."
        new_node: "Новый"

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
            url: "/#{collection}/#{root_id}.json"
            data: (n)->
              id: (if n.attr then n.attr("id") else 0)

    contextmenu:
      select_node: true
      items:
        create:
          label: "Создать"
          action: (obj)->
            group_id = obj[0].id.replace("#{model_name}_", "")
#            $.get "/#{collection}/new.js", {"#{model_name}": {parent_id: group_id}}

          separator_after: true

        edit:
          label: "Редактировать"
          action: (obj)->
            group_id = obj[0].id.replace("#{model_name}_", "")
            $.get "/#{collection}/#{group_id}/edit.js"

        rename:
          label: "Переименовать"
          action: (obj)->
            @rename obj

          separator_after: true

        remove:
          label: "Удалить"
          action: (obj)->
            if confirm("Вы уверены?")
              if @is_selected(obj)
                @remove()
              else
                @remove obj

    plugins: ["themes", "html_data", "ui", "contextmenu", "crrm"]
  )