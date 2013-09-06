jQuery ->

  $(document).on 'click', '.close_product_form', ->
    $('#product_form').html('')
    $('#product_form').slideUp()
