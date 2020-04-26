(function(){
  $(function(){
    $(document).on('change', '.data_storage-checkbox', function(event) {
      var $input = $(this).closest('.data_storage-input');
      var $checkboxes = $input.find('.data_storage-checkbox:checked');
      varchecked_storages = $checkboxes.map(function(checkbox) {
        return $(this).siblings('.data_storage-label').text();
      });
      checked_storages = $.makeArray(checked_storages).join(', ');
      $input.find('.input-presentation').html(checked_storages || '-');
      $input.find('.dropdown-toggle').dropdown('toggle');
    });
  })
}).call(this)
