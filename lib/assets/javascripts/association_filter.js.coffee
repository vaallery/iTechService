(($) ->
  $.fn.filterAssociation = ->
    $.expr[":"].Contains = (a, i, m) ->
      (a.textContent or a.innerText or "").toUpperCase().indexOf(m[3].toUpperCase()) >= 0
    $(this).keyup ->
      value = $(this).val()
      $list = $(this).next('.list')
      if value
        $(".item:not(:Contains(#{value}))", $list).hide()
        $(".item:Contains(#{value})", $list).show()
      else
        $(".item", $list).show()
      false
    this
) $