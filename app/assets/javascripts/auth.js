//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap

(function(){
  var scan_card = function() {
    var card_number = '';
    $('#card_sign_in').show().addClass('in');
    $(document).on('keydown', function(event) {
      if ($('#card_sign_in.in:visible').length > 0) {
        if (event.keyCode === 13 && card_number !== '') {
          return sign_in_by_card(card_number);
        } else {
          return card_number += String.fromCharCode(event.keyCode).toLowerCase();
        }
      }
    });
    return setTimeout((function() {
      if (card_number !== '') {
        sign_in_by_card(card_number);
      } else {
        $('#card_sign_in').removeClass('in').hide();
      }
      return card_number = '';
    }), 3000);
  };

  var sign_in_by_card = function(number) {
    $.post('/users/sign_in_by_card.json', {
      card_number: number,
      current_user: null
    }, function(data) {
      window.location.assign('/');
    }, 'json');
  };

  $(function(){
    $('#sign_in_by_card').click(function(event) {
      event.preventDefault();
      return scan_card();
    });
  })
}).call(this);