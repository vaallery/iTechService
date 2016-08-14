$(document).on 'change', '.product_group_select', ->
  id = $(this).val()
  $('#product_options,#item_features').html('')
  unless id is ''
    $.getScript "/product_groups/#{id}/select?scope=items"

$(document).on 'change', '.item_form .product_option, .item_form  .product_group_select', ->
  product_group_id = $('.product_group_select').val()
  option_ids = $('#product_options select').serialize()
  unless product_group_id is ''
    $.getScript "/products/find.js?product_group_id=#{product_group_id}&#{option_ids}"
