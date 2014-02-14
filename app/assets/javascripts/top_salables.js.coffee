jQuery ->

  $('#top_salable_type').change ->
    $form = $('#top_salable_form')
    $('#product_select_field', $form).addClass('hidden')
    $('#group_select_field', $form).addClass('hidden')
    switch $(this).val()
      when 'Product'
        $('#product_select_field', $form).removeClass('hidden')
        $('#top_salable_name').val('')
      when 'Group'
        $('#group_select_field', $form).removeClass('hidden')
        $('#top_salable_product_id').val('')
        $('#top_salable_product_select').text('...')
