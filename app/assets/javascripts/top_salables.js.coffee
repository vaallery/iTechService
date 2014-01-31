jQuery ->

  $('#top_salable_salable_type').change ->
    $form = $('#top_salable_form')
    $('#product_select_field', $form).hide()
    $('#product_group_select_field', $form).hide()
    switch $(this).val()
      when 'Product'
        $('#product_select_field', $form).show()
      when 'ProductGroup'
        $('#product_group_select_field', $form).show()
