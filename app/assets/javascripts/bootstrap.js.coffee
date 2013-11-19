jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
  $(".collapse").collapse()
  $(".dropdown-toggle").dropdown()
  $('.datetimepicker').datetimepicker
    language: 'ru'
    format: 'dd.MM.yyyy hh:mm'
    maskInput: false
    pickDate: true
    pickTime: true
    pick12HourFormat: false
    pickSeconds: false
    startDate: new Date()
