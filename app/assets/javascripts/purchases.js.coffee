jQuery ->

  $(document).on 'blur', '.batch_fields>.price>input, .batch_fields>.quantity>input', ->
    $row = $(this).closest('.batch_fields')
    price = Number($('.price>input', $row).val())
    quantity = Number($('.quantity>input', $row).val())
    $('.sum>input', $row).val(price * quantity)

    total_sum = 0
    $('#purchase_products .batch_fields').each ->
      sum = Number($(this).find('.sum>input').val())
      total_sum = total_sum + sum

    $('#purchase_products .total_sum').text(total_sum)

  $(document).on 'click', '.add_fields, .remove_fields', ->
    num = 0
    $('#purchase_products .batch_fields:visible').each ->
      $(this).find('.num').text(++num)
