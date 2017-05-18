#App.SubstitutePhone =
#
#  select =

$(document).on 'click', '[data-behaviour~=select-substitute-phone]', (event)->
  event.preventDefault()
  $substitute_phone = $(this).closest('.substitute_phone')
  id = $substitute_phone.data('id')
  name = $substitute_phone.find('.name').text()
  serial_number = $substitute_phone.find('.serial_number').text()
  $input = $('.substitute_phone.input')
  $input.find('.substitute_phone_id').val(id)
  $input.find('input[type=text]').val("#{name} / #{serial_number}")
  App.closeModal()

$(document).on 'click', '#phone_substitution_condition_match_0', (event)->
  document.getElementById('phone_substitution_manager_informed').checked = false
  $('.control-group.phone_substitution_manager_informed').removeClass('hidden')

$(document).on 'click', '#phone_substitution_condition_match_1', (event)->
  document.getElementById('phone_substitution_manager_informed').checked = false
  $('.control-group.phone_substitution_manager_informed').addClass('hidden')
