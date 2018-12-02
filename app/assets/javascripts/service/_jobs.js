(function() {
  App.Service.Jobs = {
    close_sms_notification_form: function() {
      $('#sms_notification_form_container').html('');
      $('#device_notes_container').show();
    }
  };
}).call(this);
