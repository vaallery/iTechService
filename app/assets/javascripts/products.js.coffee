jQuery ->

  $(document).on 'click', '.product_selector .product_link', ->
    slideSpeed = 100
    $link = $(this)
    $li = $link.parent()
    $list = $link.next('ul')

    if $li.hasClass('opened')
      $list.find('ul li').slideUp(slideSpeed).removeClass('opened').addClass('closed')
      $list.find('ul').addClass('hidden')
      $list.children('li').slideDown(slideSpeed).removeClass('opened').addClass('closed')
    else
      $list = $link.next('ul')
      $li.prevAll('li').slideUp(slideSpeed)
      $li.nextAll('li').slideUp(slideSpeed)
      $list.removeClass('hidden')
      $list.children('li').slideDown(slideSpeed).removeClass('opened').addClass('closed')
      $li.removeClass('closed').addClass('opened')

    if $list.hasClass('empty')
      $selector = $li.closest('.product_selector')
      $('.product_name', $selector).text($li.attr('product_name'))
      $('input.product_id', $selector).val($li.attr('product_id'))
      $('.product_select_button', $selector).parent().removeClass('open')

    false

  $(document).on 'click', '.product_selector .clear_product', ->
    $selector = $(this).closest('.product_selector')
    $list = $('.products_list', $selector)
    $('li', $list).removeClass('opened').addClass('closed').hide()
    $('li>ul', $list).addClass('hidden')
    $list.children('li').show()
    $('.product_name', $selector).text('-')
    $('.product_selector', $selector).next('.product_id').val('')

  $(document).on 'change', '#product_category_id', ->
    id = $(this).val()
    $('#feature_types').load '/products/category_select?category_id=' + id, ->
      if $('#feature_types').length > 0
        $('#feature_types').removeClass('hidden')
      else
        $('#feature_types').addClass('hidden')
