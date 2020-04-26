(function(){
  $(document).on('click', '#client_input #client_transfer_link', function(event) {
    var $link = $(this);
    var client_search = $link.siblings('#client_search').val();
    var client_id = $link.siblings('.client_id').val();
    var base_href = $link.attr('href').split('?')[0];
    var param = client_id.length > 0 ? "service_job[client_id]=" + client_id : "client=" + client_search;
    $link.attr('href', base_href + "?" + param);
  });

  $(document).on('change', '#client_input #client_search', function(event) {
    $(this).siblings('.client_id').val('');
  });
}).call(this)
