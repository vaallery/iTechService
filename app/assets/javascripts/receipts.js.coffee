App.Receipts =

  removeProduct: (sender)->
    $fields = $(sender).closest('.product-fields')
    $fields.remove()
    @calculate()

  calculate: ->
    $form = $('#receipt-form')
    $products = $form.find('.product-fields')
    sum = 0
    $products.each ->
      price = $('.price', this).val()
      quantity = $('.quantity', this).val()
      sum += price * quantity
    $('#receipt-sum-value').val sum
    $('.receipt-sum', $form).text accounting.formatMoney(sum)
    $('#receipt-sum-in-words').val sum2str(sum)

jQuery ->

  if $('#receipt-form').length

    $(document).on 'click', '[data-behavior~=remove-receipt-product]', (event)->
      event.preventDefault()
      App.Receipts.removeProduct this

  else
    $(document).off 'click', '[data-behavior~=remove-receipt-product]'