(function() {
  App.Service.Jobs = {
    close_sms_notification_form: function() {
      $('#sms_notification_form_container').html('');
      $('#device_notes_container').show();
    },

    fetch_stale: function() {
      $.getScript('/service_jobs/stale.js');
    }
  };

  $(function() {
    if ($('#stale_jobs-link-1').length > 0) {
      App.Service.Jobs.fetch_stale();
    }
  })
}).call(this);
