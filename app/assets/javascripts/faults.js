(function() {
  $(function() {
    $(document).on('change', '#fault_kind_id', function(event){
      var id = $(this).val();
      var kind = $(this).data(id);
      var $penalty = $('#fault_penalty');

      $(this).siblings('.help-block').html(kind.description);

      if (kind.is_financial) {
        $('.fault_penalty').removeClass('hidden');
        $penalty.focus();
      } else {
        $('.fault_penalty').addClass('hidden');
        $penalty.val(null);
      }
    })
  })
}).call(this);
