jQuery ->

  $(document).on 'click', 'table#store_products tr.product.detailable>td', (event)->
    if event.toElement == this
      $.get $(this).closest('tr').data('path')