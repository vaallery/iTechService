(function(){
  App.Service.FreeJobs = {

  };

  $(function(){
    $('.service_free_job_task_id').change(function(event) {
      var id = $(this).val();
      $.get('/service/free_jobs/performer_options?task_id=' + id, function(options) {
        var $input = $('#service_free_job_performer_id');
        $input.html('<option value=""></option>' + options);

        if (options === "") {
          $input.val(null);
          $input.attr('disabled', 'disabled');
          $input.addClass('disabled')
        } else {
          $input.removeAttr('disabled');
          $input.removeClass('disabled')
        }
      })
    })
  })
}).call(this);