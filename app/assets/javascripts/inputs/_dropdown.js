(function(){
  $(function(){
    $(document).on('click', 'a.dropdown-input-item', function(event) {
      var $this = $(this);
      var $input = $this.closest('.dropdown-input');
      $input.find('.input-presentation').html($this.html());
      $input.find('.input-value').val($this.data('value'));
      event.preventDefault();
    });
  })
}).call(this)
