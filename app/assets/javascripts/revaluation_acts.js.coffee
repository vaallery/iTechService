jQuery ->

  if $('#revaluations').length > 0
    enumerate_table('#revaluations')
    $(document).on 'click', '.add_fields, .remove_fields', ->
      enumerate_table('#revaluations')
