jQuery ->

  $(document).on 'change', '#supplies_table .fields .quantity, #supplies_table .fields .cost', ->
    $row = $(this).closest('tr.fields')
    qty = parseInt($('.quantity>input', $row).val()) || 0
    cost = parseFloat($('.cost>input', $row).val()) || 0
    sum = qty * cost
    $('.sum', $row).text(sum)
    $.map $('#supplies_table>tbody>tr:visible'), (row, i)->
      parseFloat $('.sum', row).text()