//= require_self
//= require ./_client
//= require ./_data_storage
//= require ./_device
//= require ./_dropdown
//= require ./_location

App.Inputs = {};

$(function(){
  $(document).on('focus', 'textarea', function() {
    $('textarea.focus').removeClass('focus');
    $(this).addClass('focus');
  });
})
