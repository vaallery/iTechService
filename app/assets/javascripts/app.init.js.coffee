window.App ||= {}

App.init = ->

  Turbolinks.enableProgressBar(true);

  #== Open external links in new window
#  $("a[href^='http']").attr('target', '_blank')

$(document).on 'page:change', ->
  App.init()
