jQuery ->

$(document).on 'change', '#payments_table .payment_kind', ->
  $this = $(this)
  $row = $this.closest('.payment_fields')
  $('.addl_attr>*', $row).addClass('hidden')
  switch $this.val()
    when 'card', 'credit' then $('.bank_field', $row).removeClass('hidden')
    when 'certificate' then $('.gift_certificate_field', $row).removeClass('hidden')
    when 'trade_in' then $('.trade_in_field', $row).removeClass('hidden')