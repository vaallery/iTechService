#  $("a[rel~=popover]").popover()
#  $("a[rel~=tooltip], .tooltip").tooltip()
jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
  $(".collapse").collapse()
  $(".dropdown-toggle").dropdown()

  $('.datetimepicker').datetimepicker
    language: 'ru'
    format: 'dd.MM.yyyy hh:mm'
    weekStart: 1
    maskInput: false
    pickDate: true
    pickTime: true
    pick12HourFormat: false
    pickSeconds: false
    startDate: new Date()

  $('.bootstrap-datepicker').datepicker
    language: 'ru'
    format: 'dd.mm.yyyy'
    weekStart: 1
    maskInput: false
    pickDate: true
    pickTime: false
    pick12HourFormat: false
    pickSeconds: false
    startDate: new Date()
